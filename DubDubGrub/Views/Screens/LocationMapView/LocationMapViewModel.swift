//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import MapKit

final class LocationViewModel: NSObject, ObservableObject {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
                                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    @Published var alertItem: AlertItem?
    
    @Published var isShowingOnbardView = false
    
    // Optional to check if location services in enabled
    var deviceLocationManager: CLLocationManager?
    let kHasSeenOnboardView = "hasSeenOnboardView"
    
    var hasSeenOnboardView: Bool {
        // if not set then defaults to false
        UserDefaults.standard.bool(forKey: kHasSeenOnboardView)
    }
    
    func runStartupChecks() {
        //check where this user has seen the onbard screen
        if !hasSeenOnboardView {
            isShowingOnbardView = true
            
            // Set the default (which persists) to true
            UserDefaults.standard.set(true, forKey: kHasSeenOnboardView)
        } else {
            checkIfLocationServicesIsEnabled()
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            deviceLocationManager = CLLocationManager()
            
            deviceLocationManager!.delegate = self
            //Accuracy. (this is the default)
            //deviceLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            //Do an alert
            alertItem = AlertContext.locationDisabled
        }
    }
    
    private func checkLocationAuthorization() {
        guard let deviceLocationManager = deviceLocationManager else {
            return
        }
        
        switch deviceLocationManager.authorizationStatus {
        case .notDetermined:
            deviceLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show alert
            alertItem = AlertContext.locationRestricted
        case .denied:
            // show alert
            alertItem = AlertContext.locationDenied
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
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
    
}

// Check when the user changed prefereces outside the app
extension LocationViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
