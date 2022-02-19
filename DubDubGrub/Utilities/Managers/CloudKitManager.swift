//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//
// All the communication needed is being implemented here

import CloudKit

struct CloudKitManager {
    
    static func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        
        //recordType -- give our DDGLocations
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        //Main container
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            // If went bad
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            //Just in case we are not force-unwrapping data here and cause unexpected crash
            //If good
            guard let records = records else { return }
            
            //$0 means as you iterate through the array
            let locations = records.map {$0.convertToDDGLocation()}
            
//            var locations: [DDGLocation] = []
//
//            for record in records {
//                let location = DDGLocation(record: record)
//                locations.append(location)
//            }
            
            completed(.success(locations))
        }
    }
}
