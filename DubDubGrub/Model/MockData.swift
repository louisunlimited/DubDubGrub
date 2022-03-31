//
//  MockData.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import CloudKit
import UIKit

struct MockData {
    
    static var location: CKRecord {
        let record = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName] = "Bar and Grill"
        record[DDGLocation.kAdress] = "123 Main street"
        record[DDGLocation.kDescription] = "This is a test description isn't is awesome? Yayyyyyyyy"
        record[DDGLocation.kWebsiteURL] = "https://www.apple.com"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "217-200-3431"
        
        return record
    }
    
    static var chipotle: CKRecord {
        let record                          = CKRecord(recordType: RecordType.location,
                                                       recordID: CKRecord.ID(recordName: "BD731330-6FAF-A3DE-2592-677F9A62BBCA"))
        record[DDGLocation.kName]           = "Chipotle"
        record[DDGLocation.kAdress]         = "1 S Market St Ste 40"
        record[DDGLocation.kDescription]    = "Our local San Jose One South Market Chipotle Mexican Grill is cultivating a better world by serving responsibly sourced, classically-cooked, real food."
        record[DDGLocation.kWebsiteURL]     = "https://locations.chipotle.com/ca/san-jose/1-s-market-st"
        record[DDGLocation.kLocation]       = CLLocation(latitude: 37.334967, longitude: -121.892566)
        record[DDGLocation.kPhoneNumber]    = "408-938-0919"
        
        return record
    }
    
    static var profile: CKRecord {
        let record = CKRecord(recordType: RecordType.profile)
        record[DDGProfile.kFirstName] = "Lous"
        record[DDGProfile.kLastName] = "Q"
        record[DDGProfile.kCompanyName] = "My Company"
        record[DDGProfile.kBio] = "This is a test description isn't is awesome? Yayyyyyyyy"
        
        return record
    }
}

