//
//  CKRecord+Ext.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import CloudKit

extension CKRecord {
    func convertToDDGLocation() -> DDGLocation { DDGLocation(record: self) }
    func convertToDDGProfile() -> DDGProfile { DDGProfile(record: self) }
}
