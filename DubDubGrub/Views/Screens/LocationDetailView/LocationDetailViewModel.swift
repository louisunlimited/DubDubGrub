//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 2/22/22.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus {
    case checkedIn, checkedOut
}

extension LocationDetailView {
    
    final class LocationDetailViewModel: ObservableObject {
        
        @Published var isLoading = false
        @Published var checkedInProfiles: [DDGProfile] = []
        @Published var isCheckedIn = false
        @Published var isShowingProfileModal = false
        @Published var isShowingProfileSheet = false
        @Published var alertItem: AlertItem?
        
        var location: DDGLocation
        
        var selectedProfile: DDGProfile?
        
        var buttonColor: Color { isCheckedIn ? .grubRed : .brandPrimary }
        
        var buttonImageTitle: String { isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark" }
        
        var buttonA11yLabel: String { isCheckedIn ? "Check out of location" : "Check into location" }
        
        init(location: DDGLocation) {
            self.location  = location
        }
        
        func determineColumns(for dynamicTypeSize: DynamicTypeSize) -> [GridItem] {
            let numberOfCols = dynamicTypeSize >= .accessibility3 ? 1 : 3
            return Array(repeating: GridItem(.flexible()), count: numberOfCols)
        }
        
        func getDirectionsToLocation() {
            let placeMark = MKPlacemark(coordinate: location.location.coordinate)
            // The 'thing' on the map
            let mapItem = MKMapItem(placemark: placeMark)
            mapItem.name = location.name
            
            // This gives customized direction between two directions
            //MKMapItem.openMaps(with: T##[MKMapItem], launchOptions: T##[String : Any]?)
            
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        }
        
        
        func callLocation() {
            guard let url = URL(string: "tel://\(location.phoneNumber)") else {
                alertItem = AlertContext.invalidPhoneNumber
                return
            }
            //        if UIApplication.shared.canOpenURL(T##url: URL##URL) {
            //
            //        } else {
            //
            //        }
            UIApplication.shared.open(url)
        }
        
        
        func getCheckedInStatus() {
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
            
            CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
                DispatchQueue.main.async { [self] in
                    switch result{
                    case .success(let record):
                        if let reference = record[DDGProfile.kIsChechedIn] as? CKRecord.Reference {
                            //                        if reference.recordID == location.id {
                            //                            isCheckedIn = true
                            //                        } else {
                            //                            isCheckedIn = false
                            //                        }
                            isCheckedIn = reference.recordID == location.id
                        } else {
                            isCheckedIn = false
                        }
                    case .failure(_):
                        alertItem = AlertContext.unableToGetCheckInStatus
                    }
                }
            }
        }
        
        
        func updateCheckInStatus(to checkInStatus: CheckInStatus) {
            // Get DDG Profile
            
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            showLoadingView()
            
            CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
                switch result {
                case .success(let record):
                    // Create reference to Location
                    switch checkInStatus {
                    case .checkedIn:
                        record[DDGProfile.kIsChechedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                        record[DDGProfile.kIsCheckedInNilCheck] = 1
                    case .checkedOut:
                        record[DDGProfile.kIsChechedIn] = nil
                        record[DDGProfile.kIsCheckedInNilCheck] = nil
                    }
                    
                    // Save the updated profile to CloudKit
                    CloudKitManager.shared.save(record: record) { result in
                        DispatchQueue.main.async { [self] in
                            hideLoadingView()
                            switch result{
                            case .success(let record):
                                Hapticmanager.playSuccess()
                                let profile = DDGProfile(record: record)
                                switch checkInStatus {
                                case .checkedIn:
                                    // update checkedInProfiles array
                                    checkedInProfiles.append(profile)
                                case .checkedOut:
                                    checkedInProfiles.removeAll(where: {$0.id == profile.id})
                                }
                                
                                isCheckedIn.toggle()
                                
                            case .failure(_):
                                alertItem = AlertContext.unableToCheckInOrOut
                            }
                        }
                    }
                    
                case .failure(_):
                    hideLoadingView()
                    alertItem = AlertContext.unableToCheckInOrOut
                }
            }
        }
        
        
        func getCheckedInProfiles() {
            showLoadingView()
            CloudKitManager.shared.getCheckedInProfiles(for: location.id) { [self] result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let profiles):
                        checkedInProfiles = profiles
                    case .failure(_):
                        alertItem = AlertContext.unableToGetCheckInProfiles
                    }
                    hideLoadingView()
                }
            }
        }
        
        
        func show(_ profile:DDGProfile, in dynamicTypeSize:DynamicTypeSize) {
            selectedProfile = profile
            if dynamicTypeSize >= .accessibility3 {
                isShowingProfileSheet = true
            } else {
                isShowingProfileModal = true
            }
        }
        
        private func showLoadingView() {isLoading = true}
        private func hideLoadingView() {isLoading = false}
        
    }
}
