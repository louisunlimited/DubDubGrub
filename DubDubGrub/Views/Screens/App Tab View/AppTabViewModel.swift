//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 2/24/22.
//

import CoreLocation
import SwiftUI

extension AppTabView {
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        @Published var isShowingOnbardView = false
        @Published var alertItem: AlertItem?
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnbardView = hasSeenOnboardView}
        }
        
        var deviceLocationManager: CLLocationManager?
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        
        
        func runStartupChecks() {
            //check where this user has seen the onbard screen
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
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
        // Check when the user changed prefereces outside the app
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    }
}
