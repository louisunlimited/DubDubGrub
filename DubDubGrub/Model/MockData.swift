//
//  MockData.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import CloudKit

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
}

