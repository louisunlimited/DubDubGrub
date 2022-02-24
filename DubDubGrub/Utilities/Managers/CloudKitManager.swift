//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//
// All the communication needed is being implemented here

import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    var profileRecordID: CKRecord.ID?
    
    // Cannot be initialized anywhere else
    private init() {}
    
    var userRecord: CKRecord?
    
    // Called on the background
    func getUserRecord() {
        CKContainer.default().fetchUserRecordID {recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.userRecord = userRecord
                
                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference {
                    self.profileRecordID = profileReference.recordID
                }
            }
        }
    }
    
    func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void) {
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
    
    func getCheckedInProfiles(for locationID:CKRecord.ID, completed: @escaping(Result<[DDGProfile], Error>) -> Void) {
        // put restaurant to each person: WWDC16 CloudKit Best Practices
        // Back Pointers
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) {records, error in
            guard let records = records, error == nil else {
                completed(.failure(error!))
                return
            }
            let profile = records.map {$0.convertToDDGProfile()}
            completed(.success(profile))
        }
    }
    // Gets all profiles into a Dict
    func getCheckedInProfilesDictionary(completed: @escaping(Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void) {
        let preidcate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query  = CKQuery(recordType: RecordType.profile, predicate: preidcate)
        let operation = CKQueryOperation(query: query)
//        operation.desiredKeys = [DDGProfile.kIsChechedIn, DDGProfile.kAvatar]
        
        var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        operation.recordFetchedBlock = {record in
            // Build dict
            let profile = DDGProfile(record: record)
            
            guard let locationReference = profile.isCheckedIn else { return }
            
            // Look for the record ID, if exist -> append, else default to []
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
            
        }
        // cursor: CloudKit has a limit
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            // Handel cursor
            completed(.success(checkedInProfiles))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func batchSave(records: [CKRecord], completed: @escaping(Result<[CKRecord], Error>) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        //= {savedRecords,  , error in}
        operation.modifyRecordsCompletionBlock = {savedRecords,  _, error in
            guard let savedRecords = savedRecords, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(savedRecords))
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func save(record: CKRecord, completed: @escaping(Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
    
    func fetchRecord(with id: CKRecord.ID, completed: @escaping(Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
}
