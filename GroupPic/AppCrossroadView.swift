//
//  AppCrossroadView.swift
//  GroupPic
//
//  Created by Paul Festor on 24/07/2022.
//

import SwiftUI
import AVFoundation

struct AppCrossroadView: View {
    
    @State var authorisationStatus: AVAuthorizationStatus? = nil
    
    @AppStorage("showOnboarding") var showOnboarding = true
    
    var body: some View {
        
        MainView()
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView(isPresented: $showOnboarding)
            }
//        ImagesCombinationView(
//            frontImage: UIImage(named: "frontimage")!,
//            backImage: UIImage(named: "backimage")!) {}
//        ZStack {
//            Color.appBackground.edgesIgnoringSafeArea(.all)
//            if authorisationStatus == .authorized {
//                MainView()
//            } else {
//                AccessRequestView(videoAuthorisationStatus: $authorisationStatus)
//                    .transition(.move(edge: .bottom))
//            }
//        }.onAppear {
//            withAnimation { authorisationStatus = AVCaptureDevice.authorizationStatus(for: .video) }
//        }
    }
}

struct AppCrossroadView_Previews: PreviewProvider {
    static var previews: some View {
        AppCrossroadView()
    }
}
