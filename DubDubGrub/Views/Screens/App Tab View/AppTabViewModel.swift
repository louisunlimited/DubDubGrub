//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 2/24/22.
//

import CoreLocation

final class AppTabViewModel: NSObject, ObservableObject {
    
    @Published var isShowingOnbardView = false
    @Published var alertItem: AlertItem?
    
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
}


// Check when the user changed prefereces outside the app
extension AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
