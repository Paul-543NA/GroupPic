//
//  SettingsSheet.swift
//  GroupPic
//
//  Created by Paul Festor on 24/07/2022.
//

import SwiftUI

struct SettingsSheet: View {
    
    @Binding var isPresented: Bool
    @AppStorage("useAutomaticAIScaling") var useAutomaticAIScaling = true

    var settingsHeader: some View {
        HStack {
            Text(LocStrings.settings)
                .font(.largeTitle)
                .foregroundColor(.appHighlight)
            Spacer()
            Button(LocStrings.done) {
                isPresented = false
            }
        }
    }
    
    var settingsActionsView: some View {
        VStack {
            Toggle(LocStrings.auto_scaling, isOn: $useAutomaticAIScaling)
                .padding(.bottom, 5)
            Text(LocStrings.auto_scaling_desc)
                .font(.caption)
        } // VStack
        .foregroundColor(.appHighlight)
        .padding()
        .background(Color.appBackgroundLight, in: RoundedRectangle(cornerRadius: 10))
    }
    
    var privacyPolicyText: some View {
        Text(.init(LocStrings.privacy_policy))
            .multilineTextAlignment(.leading)
            .foregroundColor(.white.opacity(0.7))
            .accentColor(.blue.opacity(0.7))
            .font(.caption)
            .padding(.horizontal)
    }
    
    var body: some View {
        VStack {
            settingsHeader
            .padding()
            settingsActionsView
            Spacer()
            privacyPolicyText
        } // VStack
        .padding()
        .background(Color.appBackground)
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet(isPresented: .constant(true))
    }
}
