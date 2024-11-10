//
//  ContentView.swift
//  GroupPic
//
//  Created by Paul Festor on 17/07/2022.
//

import SwiftUI
import UIKit
import StoreKit

struct MainView: View {
    
    @ObservedObject var mainVC = MainVC()
    @State var imageSourceType: UIImagePickerController.SourceType = .camera
    @State var isCameraPresented = false
    
    @State var successAlertShown = false
    var successAlertValishDelay = 0.9
    
    @State var isSettingsPresented: Bool = false
    @State var reviewProba: CGFloat = 0.4

    var mainButton: some View {
        Button {
            withAnimation { isCameraPresented = true }
        } label: {
            Image(systemName: "camera.circle")
            .symbolRenderingMode(.monochrome)
            .foregroundColor(Color.appHighlight)
            .font(.system(size: 160, weight: .regular))
        }

    }
    
    var header: some View {
        HStack {
            Spacer()
            Button {
                isSettingsPresented.toggle()
            } label: {
                Image(systemName: "gearshape")
                .symbolRenderingMode(.monochrome)
                .foregroundColor(Color.appHighlight)
                .font(.system(size: 46, weight: .regular))
            }
        }
    }
    
    var successAlertView: some View {
        VStack {
            Spacer()
            VStack {
                Image(systemName: "checkmark.circle")
                .symbolRenderingMode(.monochrome)
                .foregroundColor(Color.green)
                .font(.system(size: 130))
                Text(LocStrings.photo_saved)
                    .padding(.top)
                    .font(.title)
                    .foregroundColor(.appHighlight)
            }
            .frame(width: 250, height: 300, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.appBackgroundLight)
            )

            Spacer()
        }.onAppear {
            // Show app review popup with probability reviewProba
            let rand = CGFloat.random(in: 0...1)
            if rand < reviewProba { SKStoreReviewController.requestReviewInCurrentScene() }
        }
    }
    
    var body: some View {
        if mainVC.frontImage != nil {
            ZStack {
                Color.appBackground.edgesIgnoringSafeArea(.all)
                ImagesCombinationView(
                    frontImage: mainVC.frontImage!,
                    backImage: mainVC.backImage!
                ) {
                    // Reset the app
                    successAlertShown = true
                    withAnimation {
                        self.isCameraPresented = false
                        mainVC.status = .noPicsTaken
                        mainVC.backImage = nil
                        mainVC.frontImage = nil
                    }
                    _ = Timer.scheduledTimer(withTimeInterval: successAlertValishDelay, repeats: false, block: { _ in
                        withAnimation {
                            successAlertShown = false
                        }
                    })
                }//ImagesCombinationView
            }// ZStack
            .transition(.move(edge: .bottom))
        } else {
            ZStack {
                Color.appBackground.edgesIgnoringSafeArea(.all)
                
                VStack {
                    header
                    Spacer()
                    mainButton
                    Spacer()
                }.padding()
                
                if successAlertShown {
                    successAlertView
                    .padding()
                    .zIndex(1) // This is to see the disappearing animation. Without that, the view is sent to the back when disapearing.
                    .transition(.opacity)
                }
                
                if self.isCameraPresented && mainVC.backImage == nil {
                    ImagePickerView(
                        isPresented: self.$isCameraPresented,
                        selectedImage: $mainVC.backImage,
                        sourceType: imageSourceType,
                        cameraSide: .rear
                    )
                    .transition(.move(edge: .bottom))
                } else if mainVC.backImage != nil && mainVC.frontImage == nil {
                    ImagePickerView(
                        isPresented: self.$isCameraPresented,
                        selectedImage: $mainVC.frontImage,
                        sourceType: imageSourceType,
                        cameraSide: .front
                    )
                    .transition(.move(edge: .bottom))
                }

                
            } // ZStack
            .sheet(isPresented: $isSettingsPresented) {
                SettingsSheet(isPresented: $isSettingsPresented)
            }.preferredColorScheme(.dark)
        }
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.locale, .init(identifier: "fr"))
    }
}
