//
//  VideoPost.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import Foundation
import CloudKit

struct VideoPost: Identifiable {
    let id: CKRecord.ID
    let videoURL: URL
    let caption: String
    let creationDate: Date

    init(record: CKRecord) {
        self.id = record.recordID
        self.videoURL = record["videoURL"] as! URL
        self.caption = record["caption"] as! String
        self.creationDate = record.creationDate ?? Date()
    }

    static func createRecord(videoURL: URL, caption: String) -> CKRecord {
        let record = CKRecord(recordType: "VideoPost")
        record["videoURL"] = videoURL as! any CKRecordValue as CKRecordValue
        record["caption"] = caption as CKRecordValue
        return record
    }
}
