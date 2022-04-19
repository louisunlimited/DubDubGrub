//
//  DDGProfile.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import CloudKit
import UIKit

struct DDGProfile: Identifiable {
    static let kFirstName = "firstName"
    static let kLastName = "lastName"
    static let kAvatar = "avatar"
    static let kCompanyName = "companyName"
    static let kBio = "bio"
    static let kIsChechedIn = "isCheckedIn"
    static let kIsCheckedInNilCheck = "isCheckedInNilCheck"
    
    
    let id: CKRecord.ID
    let firstName: String
    let lastName: String
    let avatar: CKAsset!
    let companyName: String
    let bio: String
    // If not checkin, nil
    let isCheckedIn: CKRecord.Reference?
    
    init(record: CKRecord) {
        id  = record.recordID
        // Just in case we get null
        firstName   = record[DDGProfile.kFirstName] as? String ?? "N/A"
        lastName    = record[DDGProfile.kLastName] as? String ?? "N/A"
        avatar      = record[DDGProfile.kAvatar] as? CKAsset
        companyName = record[DDGProfile.kCompanyName] as? String ?? "N/A"
        bio         = record[DDGProfile.kBio] as? String ?? "N/A"
        isCheckedIn = record[DDGProfile.kIsChechedIn] as? CKRecord.Reference
    }
    
    
    var AvatarImage: UIImage {
        guard let avatar = avatar else { return PlaceHolderImage.avatar }
        return avatar.convertToUIImage(in: .square)
    }
}
