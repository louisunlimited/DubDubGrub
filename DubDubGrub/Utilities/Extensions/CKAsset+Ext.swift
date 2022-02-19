//
//  CKAsset+Ext.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/24/22.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        // Distinguish what placeholder to use square/banner
        let placeholder = ImageDimension.getPlaceholder(for: dimension)
        
        guard let fileUrl = self.fileURL else {
            return placeholder
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? placeholder
        } catch {
            return placeholder
        }
    }
}
