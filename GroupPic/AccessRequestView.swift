//
//  AccessRequestView.swift
//  GroupPic
//
//  Created by Paul Festor on 24/07/2022.
//

import SwiftUI
import AVFoundation

struct AccessRequestView: View {
    
    @Binding var videoAuthorisationStatus: AVAuthorizationStatus?
    
    var body: some View {
        VStack {
            Spacer()

            Text("We need access to your camera")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                AVCaptureDevice.requestAccess(for: .video) { result in
                    if result { videoAuthorisationStatus = .authorized }
                    else { videoAuthorisationStatus = .denied }
                }
            } label: {
                Text("Agree")
                    .accentColor(.appHighlight)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 5)
                            .foregroundColor(.appHighlight)
                    )
            }//Button
        }//VStack
        .padding()
    }
}

struct AccessRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AccessRequestView(videoAuthorisationStatus: .constant(.notDetermined))
            .preferredColorScheme(.dark)
    }
}
