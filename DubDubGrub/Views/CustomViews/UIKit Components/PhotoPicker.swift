//
//  PhotoPicker.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/25/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let photoPicker : PhotoPicker
        
        init(photoPicker : PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            if let image = info[.originalImage] as? UIImage {
                photoPicker.image = image
            }
            picker.dismiss(animated: true)
        }
    }
}
