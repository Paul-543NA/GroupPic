//
//  ImagePickerView.swift
//  GroupPic
//
//  Created by Paul Festor on 17/07/2022.
//

import Foundation
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var cameraSide: UIImagePickerController.CameraDevice
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            if UIImagePickerController.availableMediaTypes(for: .camera)!.contains("public.image") {
                imagePicker.mediaTypes = ["public.image"]
                imagePicker.allowsEditing = false
                imagePicker.cameraDevice = cameraSide
            }
        }
        
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
//        let data = info[.mediaMetadata] as! [String: Any]
        self.picker.selectedImage = selectedImage
        self.picker.isPresented = false
    }
    
}
