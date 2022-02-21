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
    @Published var isLoading = false
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
            alertItem = AlertContext.invalidProfile
            return
        }
        
        //Create our CKRecord from the profile view
        
        let profileRecord = createProfileRecord()
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        
        showLoadingView()
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(_):
                    alertItem = AlertContext.createProfileSuccess
                    break
                case .failure(_):
                    alertItem = AlertContext.createProfileFaliure
                    break
                }
            }
        }
    }
    
    
    func getProfile() {
        
        // make sure we have a user record
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        // make sure we have a reference to a profile
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
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
                    alertItem = AlertContext.unableToGetProfile
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
    
    private func showLoadingView() {isLoading = true}
    private func hideLoadingView() {isLoading = false}
}
