//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 2/19/22.
//

import SwiftUI
import CloudKit

final class ProfileViewModel: ObservableObject {
    
    @Published var firstName   = ""
    @Published var lastName    = ""
    @Published var companyName = ""
    @Published var bio         = ""
    @Published var avatar      = PlaceHolderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var alertItem: AlertItem?
    
    func isValidProfile() -> Bool {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              !bio.isEmpty,
              avatar != PlaceHolderImage.avatar,
              bio.count <= 100 else {return false}
        return true
    }
    
    
    func createProfile() {
        guard isValidProfile() else {
            //show alert
            alertItem = AlertContext.invalidProfile
            return
        }
        
        //Create our CKRecord from the profile view
        
        let profileRecord = createProfileRecord()
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // Show an alert
            return
        }
        
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            switch result {
            case .success(_):
                // show alert
                break
            case .failure(_):
                // show alert
                break
            }
        }
    }
    
    
    func getProfile() {
        
        // make sure we have a user record
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // Show an alert
            return
        }
        // make sure we have a reference to a profile
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else {
            // show alert
            return
        }
        //get profile id from reference
        let profileRecordID = profileReference.recordID
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    // Convert to a profile
                    let profile = DDGProfile(record: record)
                    // Update UI
                    firstName = profile.firstName
                    lastName = profile.lastName
                    companyName = profile.companyName
                    bio = profile.bio
                    avatar = profile.createAvatarImage()
                    
                case .failure(_):
                    // Show alert
                    break
                }
            }
        }
    }
    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.kFirstName]   = firstName
        profileRecord[DDGProfile.kLastName]    = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio]         = bio
        profileRecord[DDGProfile.kAvatar]      = avatar.convertToCKAsset()
        
        return profileRecord
    }
}
