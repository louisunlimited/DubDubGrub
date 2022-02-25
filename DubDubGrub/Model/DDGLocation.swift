//
//  DDGLocation.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import Foundation
import CloudKit
import UIKit

struct DDGLocation: Identifiable {
//    var id: ObjectIdentifier
    
    static let kName = "name"
    static let kDescription = "description"
    static let kSquareAsset = "squareAsset"
    static let kBannerAsset = "bannerAsset"
    static let kAdress = "address"
    static let kLocation = "location"
    static let kWebsiteURL = "websiteURL"
    static let kPhoneNumber = "phoneNumber"
    
//    let ckRecordID: CKRecord.ID
    let id: CKRecord.ID
    let name: String
    let description: String
    let squareAsset: CKAsset!
    let bannerAsset: CKAsset!
    let address: String
    let location: CLLocation
    let websiteURL: String
    let phoneNumber: String
    
    init(record: CKRecord) {
        id  = record.recordID
        // Just in case we get null
        name        = record[DDGLocation.kName] as? String ?? "N/A"
        description = record[DDGLocation.kDescription] as? String ?? "N/A"
        squareAsset = record[DDGLocation.kSquareAsset] as? CKAsset
        bannerAsset = record[DDGLocation.kBannerAsset] as? CKAsset
        address     = record[DDGLocation.kAdress] as? String ?? "N/A"
        location    = record[DDGLocation.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        websiteURL  = record[DDGLocation.kWebsiteURL] as? String ?? "N/A"
        phoneNumber = record[DDGLocation.kPhoneNumber] as? String ?? "N/A"
    }
    
    //Handle nil case
    func createSquareImage() -> UIImage {
        guard let asset = squareAsset else { return PlaceHolderImage.square }
        return asset.convertToUIImage(in: .square)
    }
    
    
    func createBannerImage() -> UIImage {
        guard let asset = bannerAsset else { return PlaceHolderImage.banner }
        return asset.convertToUIImage(in: .baner)
    }
}
