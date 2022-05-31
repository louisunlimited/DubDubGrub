//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 2/19/22.
//

import CloudKit

enum ProfileContext { case create, update }

@MainActor final class ProfileViewModel: ObservableObject {
    
    @Published var isCheckedIn = false
    @Published var firstName   = ""
    @Published var lastName    = ""
    @Published var companyName = ""
    @Published var bio         = ""
    @Published var avatar      = PlaceHolderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    private var ExisitingProfileRecord: CKRecord? {
        didSet { profileContext = .update }
    }
    // default state
    var profileContext: ProfileContext = .create
    
    
    private func isValidProfile() -> Bool {
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
        
        Task {
            do {
                let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
                for record in records where record.recordType == RecordType.profile {
                    ExisitingProfileRecord = record
                    CloudKitManager.shared.profileRecordID = record.recordID
                    profileContext = .update
                    
                }
                alertItem = AlertContext.createProfileSuccess
            } catch {
                hideLoadingView()
                alertItem = AlertContext.createProfileFaliure
            }
        }
        
        
//        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
//            DispatchQueue.main.async { [self] in
//                hideLoadingView()
//                switch result {
//                case .success(let records):
//                    for record in records where record.recordType == RecordType.profile {
//                        ExisitingProfileRecord = record
//                        CloudKitManager.shared.profileRecordID = record.recordID
//                        profileContext = .update
//
//                    }
//                    alertItem = AlertContext.createProfileSuccess
//                    break
//                case .failure(_):
//                    alertItem = AlertContext.createProfileFaliure
//                    break
//                }
//            }
//        }
    }
    
    
    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                if let _ = record[DDGProfile.kIsChechedIn] as? CKRecord.Reference {
                    isCheckedIn = true
                } else {
                    isCheckedIn = false
                }
            } catch {
                print("ERROR OCCRUS!")
            }
        }
//        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
//            DispatchQueue.main.async {[self] in
//                switch result{
//                case .success(let record):
//                    if let _ = record[DDGProfile.kIsChechedIn] as? CKRecord.Reference {
//                        isCheckedIn = true
//                    } else {
//                        isCheckedIn = false
//                    }
//                case .failure(_):
//                    break
//                }
//            }
//        }
    }
    
    
    func checkOut() {
        guard let profileID = CloudKitManager.shared.profileRecordID  else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileID)
                record[DDGProfile.kIsChechedIn] = nil
                record[DDGProfile.kIsCheckedInNilCheck] = nil
                
                let _ = try await CloudKitManager.shared.save(record: record)
                Hapticmanager.playSuccess()
                isCheckedIn = false
                hideLoadingView()
                
            } catch {
                hideLoadingView()
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
//        CloudKitManager.shared.fetchRecord(with: profileID) { result in
//            switch result {
//            case .success(let record):
//                record[DDGProfile.kIsChechedIn] = nil
//                record[DDGProfile.kIsCheckedInNilCheck] = nil
//                CloudKitManager.shared.save(record: record) { [self] resul in
//                    DispatchQueue.main.async { [self] in
//                        switch result {
//                        case .success(_):
//                            isCheckedIn = false
//                        case .failure(_):
//                            alertItem = AlertContext.unableToCheckInOrOut
//                        }
//                    }
//                }
//            case .failure(_):
//                DispatchQueue.main.async {
//                    self.alertItem = AlertContext.unableToCheckInOrOut
//                }
//            }
//        }
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
        
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                ExisitingProfileRecord = record

                let profile = DDGProfile(record: record)
                firstName = profile.firstName
                lastName = profile.lastName
                companyName = profile.companyName
                bio = profile.bio
                avatar = profile.AvatarImage
                
                hideLoadingView()
            } catch {
                alertItem = AlertContext.unableToGetProfile
            }
        }
        
//        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
//            DispatchQueue.main.async { [self] in
//                switch result {
//                case .success(let record):
//                    ExisitingProfileRecord = record
//                    // Convert to a profile
//                    let profile = DDGProfile(record: record)
//                    // Update UI
//                    firstName = profile.firstName
//                    lastName = profile.lastName
//                    companyName = profile.companyName
//                    bio = profile.bio
//                    avatar = profile.AvatarImage
//
//                case .failure(_):
//                    alertItem = AlertContext.unableToGetProfile
//                    break
//                }
//            }
//        }
    }
    
    
    func updateProfile() {
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        guard let profileRecord = ExisitingProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        profileRecord[DDGProfile.kFirstName]   = firstName
        profileRecord[DDGProfile.kLastName]    = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio]         = bio
        profileRecord[DDGProfile.kAvatar]      = avatar.convertToCKAsset()
        
        showLoadingView()
        
        Task {
            do {
                let _ = try await CloudKitManager.shared.save(record: profileRecord)
                hideLoadingView()
                alertItem = AlertContext.updateProfileSuccess
            } catch {
                hideLoadingView()
                alertItem = AlertContext.updateProfileFailed
            }
        }
        
//        CloudKitManager.shared.save(record: profileRecord) { result in
//            DispatchQueue.main.async { [self] in
//                hideLoadingView()
//                switch result {
//                case .success(_):
//                    alertItem = AlertContext.updateProfileSuccess
//                case .failure(_):
//                    alertItem = AlertContext.updateProfileFailed
//                }
//            }
//        }
        
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
