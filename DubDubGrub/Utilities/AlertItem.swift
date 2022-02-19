//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    
    let title: Text
    let message: Text
    let dismissedButton: Alert.Button
}

struct AlertContext {
    
    //MARK: - MapView Errors
    static let unableToGetLocations = AlertItem(title: Text("Locations Error"),
                                                message: Text("Unable to retrieve locations at this time. \n Please try again."),
                                                dismissedButton: .default(Text("OK")))
    
    static let locationRestricted = AlertItem(title: Text("Location Restricted"),
                                                message: Text("Your location is restricted, check parental control."),
                                                dismissedButton: .default(Text("OK")))
    
    static let locationDenied = AlertItem(title: Text("Location Denied"),
                                                message: Text("DDG does not have premission to access your location. Go to ///// to fix this"),
                                                dismissedButton: .default(Text("OK")))
    
    static let locationDisabled = AlertItem(title: Text("Location Disabled"),
                                                message: Text("Your location is Dislabled. Go to settings /////"),
                                                dismissedButton: .default(Text("OK")))
    
    //MARK: - ProfileView Errors
    static let invalidProfile = AlertItem(title: Text("Invalid Profile"),
                                                message: Text("Invaid profile, please check you have entered all fields."),
                                                dismissedButton: .default(Text("OK")))
}
