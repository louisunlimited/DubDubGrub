//
//  Constants.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import Foundation
import UIKit

enum RecordType {
    static let location = "DDGLocation"
    static let profile = "DDGProfile"
}


enum PlaceHolderImage {
    static let avatar = UIImage(named: "default-avatar")!
    static let square = UIImage(named: "default-square-asset")!
    static let banner = UIImage(named: "default-banner-asset")!
}

enum ImageDimension {
    case square, baner
    
    static func getPlaceholder(for dimension: ImageDimension) -> UIImage {
        switch dimension {
        case .square:
            return PlaceHolderImage.square
        case .baner:
            return PlaceHolderImage.banner
        }
    }
}
