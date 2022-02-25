//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import MapKit
import CloudKit

final class LocationViewModel: NSObject, ObservableObject {
    
    @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
    
    @Published var isShowingDetailView = false
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
                                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @Published var alertItem: AlertItem?
    
    func getLocations(for locationManager: LocationManager) {
        CloudKitManager.shared.getLocations { [self] result in
            // Make sure we update UI in main thread???
            DispatchQueue.main.async {
                switch result {
                case .success(let locations):
                    locationManager.locations = locations
                    // Try to return helpful custom meaningfull error to end users instead of system errors.
                case .failure(_):
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
    }
    
    func getCheckedInCount() {
        CloudKitManager.shared.getCheckedInProfilesCount { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure(_):
                    //show alert
                    break
                }
            }
        }
    }
    
}

