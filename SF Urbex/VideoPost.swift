//
//  MediaItem.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import Foundation
import CloudKit


struct MediaItem: Identifiable {
    let id: CKRecord.ID
    
    let creationDate: Date

    // Photo-related
    let imageURL: URL?

    init(record: CKRecord) {
        self.id = record.recordID
        
        // Common fields
        self.creationDate = record.creationDate ?? Date()
        
        self.imageURL = (record["imageURL"] as? CKAsset)?.fileURL
    }
}
