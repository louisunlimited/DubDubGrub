//
//  UIImage+Ext.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/30/22.
//

import CloudKit
import UIKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset? {
        
        //Get our apps base document dir URL
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        //Append some unique identifier for our profile image
        let fileUrl = urlPath.appendingPathComponent("selectedAvatarImage")
        //Write the image data to the location the adress points to
        guard let imageData = jpegData(compressionQuality: 0.25) else {
            return nil
        }
        //Create our CKAsset with that URL
        do {
            try imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        } catch {
            return nil
        }
    }
}
