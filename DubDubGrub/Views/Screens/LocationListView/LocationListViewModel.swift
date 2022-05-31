//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 2/23/22.
//

import Foundation
import CloudKit
import SwiftUI

extension LocationListView {
    @MainActor final class LocationListViewModel: ObservableObject {
        
        @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        @Published var alertItem: AlertItem?
        
//        func getCheckedInProfilesDictionary() {
//            CloudKitManager.shared.getCheckedInProfilesDictionary{ result in
//                DispatchQueue.main.async {
//                    switch result{
//                    case .success(let checkedInProfiles):
//                        self.checkedInProfiles = checkedInProfiles
//                    case .failure(_):
//                        self.alertItem = AlertContext.unableToGetALLCheckInProfiles
//                    }
//                }
//            }
//        }
        func getCheckedInProfilesDictionary() {
            Task {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
                } catch {
                    alertItem = AlertContext.unableToGetALLCheckInProfiles
                }
            }
        }
        
        func createVoiceOverSummary(for location: DDGLocation) -> String {
            let count = checkedInProfiles[location.id, default: []].count
            let personPlurality = count == 1 ? "person" : "people"
            
            return "\(location.name) \(count) \(personPlurality) checked in."
        }
        
        @ViewBuilder func createLocationDetailView(for location:DDGLocation, in dynamiTypeSize : DynamicTypeSize) -> some View {
            if dynamiTypeSize >= .accessibility3 {
                LocationDetailView(viewModel: LocationDetailView.LocationDetailViewModel(location: location)).embedInScrollView()
            } else {
                LocationDetailView(viewModel: LocationDetailView.LocationDetailViewModel(location: location))
            }
        }
    }
}
