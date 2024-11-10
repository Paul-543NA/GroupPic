//
//  OnboardingView.swift
//  GroupPic
//
//  Created by Paul Festor on 03/09/2022.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        TabView {
            VStack {
                Spacer()
                Image(systemName: "camera.circle")
                    .symbolRenderingMode(.monochrome)
                    .font(.system(size: 160, weight: .regular))
                Spacer()
                Text(LocStrings.welcome)
                    .font(.title)
                    .multilineTextAlignment(.center)
                Spacer()
            }.padding()
            VStack {
                Spacer()
                Image("Onboarding 1")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Spacer()
                Text(LocStrings.onboarding_1)
                    .font(.title)
                Spacer()
            }.padding()
            VStack {
                Spacer()
                Text(LocStrings.onboarding_2)
                    .font(.title)
                Spacer()
                Image("Onboarding 2")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 500)
                    .padding()
                    .padding(.top)
                Spacer()
            }.padding()
                .padding(.bottom, 50)
            VStack {
                Spacer()
                Image("Onboarding 3")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 500)
                    .padding()
                    .padding(.bottom)
                Text(LocStrings.onboarding_3)
                    .font(.title)
                Spacer()
            }.padding()
                .padding(.bottom, 50)
            VStack {
                Spacer()
                Button { isPresented.toggle() } label: {
                    Text(LocStrings.onboarding_4)
                        .font(.largeTitle)
                }
                Spacer()
            }.padding()
            
        }.tabViewStyle(.page(indexDisplayMode: .always))
            .foregroundColor(Color.appHighlight)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.appBackground
                .edgesIgnoringSafeArea(.all)
            OnboardingView(isPresented: .constant(true))
        }
    }
}
