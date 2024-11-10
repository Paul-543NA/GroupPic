//
//  ImagesCombinationView.swift
//  GroupPic
//
//  Created by Paul Festor on 17/07/2022.
//

import SwiftUI
import UIKit

struct ImagesCombinationView: View {
    
    @ObservedObject var vc: ImagesCombinationVC
    
    init(frontImage: UIImage, backImage: UIImage, completion: @escaping () -> () ) {
        self.vc = ImagesCombinationVC(backImage: backImage, frontImage: frontImage, completion: completion)
    }
    
    var body: some View {

        GeometryReader {geometry in
            
            let uiRatio: CGFloat = min(geometry.size.width / vc.backImage.size.width, geometry.size.height / vc.backImage.size.height)
            let minY: CGFloat = geometry.size.height / 2 - vc.backImage.size.height*uiRatio / 2
            let uiXCorr: CGFloat = -1.0*uiRatio*(vc.W_b/2 - vc.W_f/2)
                    
            ZStack(alignment: .top) {
                Image(uiImage: vc.backImage)
                    .resizable()
                    .frame(
                        width: vc.W_b*uiRatio,
                        height: vc.H_b*uiRatio,
                        alignment: .center
                    )
                    .offset(x: 0, y: minY)
                
                if vc.frontImegeClip == .rectangle {
                    Image(uiImage: vc.frontImage)
                        .resizable()
                        .frame(
                            width: vc.W_f*uiRatio,
                            height: vc.H_f*uiRatio,
                            alignment: .center
                        )
                        .offset(x: uiXCorr, y: minY)
                        .offset(vc.frontImageOffset.scale(uiRatio))
                        .offset(vc.frontImageOffsetVar.scale(uiRatio))
                } else if vc.frontImegeClip == .ellipse {
                    Image(uiImage: vc.frontImage)
                        .resizable()
                        .frame(
                            width: vc.W_f*uiRatio,
                            height: vc.H_f*uiRatio,
                            alignment: .center
                        )
                        .clipShape(Ellipse())
                        .offset(x: uiXCorr, y: minY)
                        .offset(vc.frontImageOffset.scale(uiRatio))
                        .offset(vc.frontImageOffsetVar.scale(uiRatio))
                }


//                Color.red.frame(width: geometry.size.width, height:  geometry.size.height)
//                    .opacity(0.5)
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        ClipShapeToggleView(selectedShape: $vc.frontImegeClip)
                    }.padding()
                    Spacer()
                    
                    Button {vc.saveImage()} label: {
                        Text(LocStrings.save_photo)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .accentColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 60)
                                    .fill(.blue)
                            )
                    }//Button
                    .padding()
                }//VStack
            }// ZStack
            .gesture(DragGesture()
                .onChanged { gesture in
                    vc.handleOffsetChange(gesture.translation.scale(1/uiRatio))
                }
                .onEnded { _ in
                    vc.handleOffsetChangeEnd()
                }
            )// Gesture
            .gesture(MagnificationGesture()
                .onChanged { newScale in
                    vc.handleScaleChange(newScale)
                }
                .onEnded { newScale in
                    vc.handleScaleChange(newScale)
                    vc.handleScaleChangeEnd()
                }
            )
        }// Geometry
    }
}

struct ImagesCombinationView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesCombinationView(
            frontImage: UIImage(named: "frontImage")!,
            backImage: UIImage(named: "family")!) {}
    }
}

extension CGSize {
    func scale(_ s: CGFloat) -> CGSize {
        let newW = self.width * s
        let newH = self.height * s
        return CGSize(width: newW, height: newH)
    }
}
