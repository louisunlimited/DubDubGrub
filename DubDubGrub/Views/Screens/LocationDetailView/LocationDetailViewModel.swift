//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Louis Qian on 2/22/22.
//

import SwiftUI
import MapKit

final class LocationDetailViewModel: ObservableObject {
    
    @Published var isShowingProfileModal = false
    @Published var alertItem: AlertItem?
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible())]
    
    var location: DDGLocation
    
    init(location: DDGLocation) {
        self.location  = location
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
}
