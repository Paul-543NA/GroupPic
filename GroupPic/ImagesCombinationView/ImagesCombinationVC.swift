//
//  ImagesCombinationVC.swift
//  GroupPic
//
//  Created by Paul Festor on 17/07/2022.
//

import SwiftUI
import Vision

class ImagesCombinationVC: ObservableObject {
    
    var backImage: UIImage
    var frontImage: UIImage
    
    @Published var frontImageScale: CGFloat
    @Published var frontImageScaleVar: CGFloat = 1.0

    @Published var frontImageOffset: CGSize
    @Published var frontImageOffsetVar: CGSize = CGSize(width: 0, height: 0)

    
    @Published var W_b: CGFloat
    @Published var H_b: CGFloat
    
    var W_f_0: CGFloat
    var H_f_0: CGFloat
    var s_max: CGFloat
    @Published var W_f: CGFloat
    @Published var H_f: CGFloat
    
    let completion: () -> ()
    
    enum ClipShape {
        case rectangle
        case ellipse
    }
    @Published var frontImegeClip: ClipShape = .ellipse

    @AppStorage("useAutomaticAIScaling") var useAutomaticAIScaling = true
    
    init(backImage: UIImage, frontImage: UIImage, completion: @escaping () -> () ) {
        self.backImage = backImage
        self.frontImage = frontImage
        self.completion = completion
        
        // Fill in geometrical parameters
        self.W_b = backImage.size.width
        self.H_b = backImage.size.height
        self.W_f_0 = frontImage.size.width
        self.H_f_0 = frontImage.size.height
        
        let s_max = min(
            backImage.size.width / frontImage.size.width,
            backImage.size.height / frontImage.size.height
        )
        
        // Set initial front image position
        var init_scale = 0.4
        self.frontImageScale = init_scale
        
        self.W_f = frontImage.size.width * s_max * init_scale
        self.H_f = frontImage.size.height * s_max * init_scale
        self.s_max = s_max
        self.frontImageOffset = CGSize(width: 50, height: 50)
        
        if useAutomaticAIScaling {
            // Set the initial scale automatically with face recognition AI
            init_scale = 0.1
            var backFacesHeights = [CGFloat]()
            var frontFacesHeights = [CGFloat]()

            // Scan back image for faces
            let backFaceDetectionRequest = VNDetectFaceRectanglesRequest { (result, error) in
                if let err = error {
                    print("Failed to detect faces: ", err)
                    return
                }
                result.results?.forEach({ (observation) in
                    guard let faceObservation = observation as? VNFaceObservation else { return }
                    let height = faceObservation.boundingBox.height
                    backFacesHeights.append(height)
                })
            }
            let backHandler = VNImageRequestHandler(cgImage: backImage.cgImage!)
            try? backHandler.perform([backFaceDetectionRequest])
            
            // Scan front image for faces
            let frontFaceDetectionRequest = VNDetectFaceRectanglesRequest { (result, error) in
                if let err = error {
                    print("Failed to detect faces: ", err)
                    return
                }
                            
                result.results?.forEach({ (observation) in
                    guard let faceObservation = observation as? VNFaceObservation else { return }
                    // %ultiply height by s_max to reach the sama space as the back image
                    let height = faceObservation.boundingBox.height
                    frontFacesHeights.append(height)
                })
            }
            let frontHandler = VNImageRequestHandler(cgImage: frontImage.cgImage!)
            try? frontHandler.perform([frontFaceDetectionRequest])
            
            
            // If faces have been detected in both images
            if frontFacesHeights.count > 0 && backFacesHeights.count > 0 {
                
                // Initialise the scale so that faces on the front and back image have the same average height on screen
                init_scale = backFacesHeights.reduce(0.0, { partialResult, elt in
                    return partialResult + elt / CGFloat(backFacesHeights.count)
                }) / frontFacesHeights.reduce(0.0, { partialResult, elt in
                    return partialResult + elt / CGFloat(frontFacesHeights.count)
                })
                // Ensure that init_scale is in ]0, 1]
                init_scale = min(init_scale, 1.0)
                
                // Adjust sizes to refkect the AI-determined scale
                self.frontImageScale = init_scale
                
                self.W_f = frontImage.size.width * s_max * init_scale
                self.H_f = frontImage.size.height * s_max * init_scale
                self.s_max = s_max
                self.frontImageOffset = CGSize(width: 50, height: 50)
            }
        } // End of AI face search
    }
    
    // MARK: - Intents
    func handleOffsetChange(_ offset: CGSize) {
        var checkedOffset = offset

        // Clip the offset to the available space
        if self.frontImageOffset.width + offset.width < 0 {
            checkedOffset.width = -self.frontImageOffset.width
        }
        if self.frontImageOffset.width + offset.width > self.W_b - self.W_f {
            checkedOffset.width = self.W_b - self.W_f - self.frontImageOffset.width
        }
        if self.frontImageOffset.height + offset.height < 0 {
            checkedOffset.height = -self.frontImageOffset.height
        }
        if self.frontImageOffset.height + offset.height > self.H_b - self.H_f {
            checkedOffset.height = self.H_b - self.H_f - self.frontImageOffset.height
        }
        
        self.frontImageOffsetVar = checkedOffset
    }
    
    func handleOffsetChangeEnd() {
        self.frontImageOffset.width += self.frontImageOffsetVar.width
        self.frontImageOffset.height += self.frontImageOffsetVar.height
        self.frontImageOffsetVar = .zero
//        let s_max = max(
//            self.H_f / (self.H_b - self.frontImageOffset.height - self.frontImageOffsetVar.height),
//            self.W_f / (self.W_b - self.frontImageOffset.width - self.frontImageOffsetVar.width)
//        )
    }
    
    func handleScaleChange(_ scale: CGFloat) {
        var checkedScale = scale
        let goesOffLimits: Bool =
            (self.H_f*scale*self.frontImageScale) > (self.H_b - self.frontImageOffset.height - self.frontImageOffsetVar.height) || (self.W_f*scale*self.frontImageScale) > (self.W_b - self.frontImageOffset.width - self.frontImageOffsetVar.width)
        if self.frontImageScale * self.frontImageScaleVar == 0.1 && scale < 1 { return }
        if goesOffLimits && scale > 1 { return }
        if self.frontImageScale * self.frontImageScaleVar < 0.1 {
            checkedScale = 0.1 / self.frontImageScale
        }
        if goesOffLimits {
            checkedScale = min(
                (self.H_b - self.frontImageOffset.height - self.frontImageOffsetVar.height) / (self.H_f*self.frontImageScale),
                (self.W_b - self.frontImageOffset.width - self.frontImageOffsetVar.width) / (self.W_f*self.frontImageScale)
            )
        }
        self.frontImageScaleVar = checkedScale
        self.updateFrontSize()
    }
    
    func handleScaleChangeEnd() {
        self.frontImageScale = self.frontImageScale * self.frontImageScaleVar
        self.frontImageScaleVar = 1.0
        self.updateFrontSize()
    }
    
    func saveImage() {
        let size = backImage.size
        UIGraphicsBeginImageContext(size)
        let backImageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backImage.draw(in: backImageRect)

        let x = frontImageOffset.width
        let y = frontImageOffset.height
                
        let height = self.H_f
        let width = self.W_f
        let areaSize = CGRect(x: x, y: y, width: width, height: height)
        
        switch frontImegeClip {
        case .rectangle:
            frontImage.draw(in: areaSize, blendMode: .normal, alpha: 1)
        case .ellipse:
            frontImage.circularImage(size: CGSize(width: width, height: height)).draw(in: areaSize, blendMode: .normal, alpha: 1)
        }
        
        
        // Circlr clipping eample code:
        // - https://gist.github.com/StanDimitroff/8fd5bccfb9f9f3fc694a4c9f164759cc
        // - https://stackoverflow.com/questions/29046571/cut-a-uiimage-into-a-circle
        // Keywords: "Cut a UIImage into a circle swift" - "Draw uiimage in Bezier path swuft"
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        self.completion()
    }
    
    func setFrontImageCrop(to newShape: ClipShape) {
        self.frontImegeClip = newShape
    }

    // MARK: - Innte logic
    private func updateFrontSize() {
        self.W_f = self.W_f_0 * s_max * self.frontImageScale * self.frontImageScaleVar
        self.H_f = self.H_f_0 * s_max * self.frontImageScale * self.frontImageScaleVar
    }
}

extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
    
    func circularImage(size: CGSize?) -> UIImage {
        let newSize = size ?? self.size

        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()

        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)


        context?.setBlendMode(.copy)
        context?.setFillColor(UIColor.clear.cgColor)

        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result!
    }
}
