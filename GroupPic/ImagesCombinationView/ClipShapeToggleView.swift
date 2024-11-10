//
//  ClipShapeToggleView.swift
//  GroupPic
//
//  Created by Paul Festor on 28/07/2022.
//

import SwiftUI
import UIKit

struct ClipShapeToggleView: View {
    @Binding var selectedShape: ImagesCombinationVC.ClipShape
    private let iconSize: CGFloat = 20
    private let generalPadding: CGFloat = 12
    private let lateralPadding: CGFloat = 5
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "oval.portrait")
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.appHighlight)
                .font(.system(size: iconSize, weight: .regular))
                .padding(generalPadding)
                .padding(.leading, lateralPadding)
                .background(selectedShape == .ellipse ? Color.blue.opacity(0.2) : Color.clear)
                .onTapGesture {
                    guard selectedShape != .ellipse else { return }
                    selectedShape = .ellipse
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                }
                
            Image(systemName: "rectangle.portrait")
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.appHighlight)
                .font(.system(size: iconSize, weight: .regular))
                .padding(generalPadding)
                .padding(.trailing, lateralPadding)
                .background(selectedShape == .rectangle ? Color.blue.opacity(0.2) : Color.clear)
                .onTapGesture {
                    guard selectedShape != .rectangle else { return }
                    selectedShape = .rectangle
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                }
        }
        .background(Color.appBackgroundLight)
        .clipShape(Capsule())
    }
}

struct ClipShapeToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ClipShapeToggleView(selectedShape: .constant(.rectangle))
            .previewLayout(.sizeThatFits)
    }
}
