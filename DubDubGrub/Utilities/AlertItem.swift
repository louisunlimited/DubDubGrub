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
    
    static let noUserRecord = AlertItem(title: Text("No User Record"),
                                                message: Text("You must log into iCloud to utilize DubDubGrub."),
                                                dismissedButton: .default(Text("OK")))
    
    static let createProfileSuccess = AlertItem(title: Text("Successfully Created Profile!"),
                                                message: Text("Your profile has been created"),
                                                dismissedButton: .default(Text("OK")))
    
    static let createProfileFaliure = AlertItem(title: Text("Failed to Created Profile"),
                                                message: Text("Your profile has not been created at this time"),
                                                dismissedButton: .default(Text("OK")))
    
    static let unableToGetProfile = AlertItem(title: Text("Unable to retrieve Profile"),
                                                message: Text("Your profile cannot be retrieved at this time"),
                                                dismissedButton: .default(Text("OK")))
    
    static let updateProfileSuccess = AlertItem(title: Text("Successfully updated Profile!"),
                                                message: Text("Your profile was updated successfully"),
                                                dismissedButton: .default(Text("OK")))
    
    static let updateProfileFailed = AlertItem(title: Text("Failed to updated Profile!"),
                                                message: Text("Your profile was not updated successfully, please check again"),
                                                dismissedButton: .default(Text("OK")))
    
    //MARK: - LocationDetailView Errors
    static let invalidPhoneNumber = AlertItem(title: Text("Invalid Phone Number"),
                                                message: Text("The Phone Number for this location is not valid"),
                                                dismissedButton: .default(Text("OK")))
}
