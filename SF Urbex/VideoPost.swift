//
//  MediaItem.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import Foundation
import CloudKit

enum MediaType {
    case video
    case photo
}

struct MediaItem: Identifiable {
    let id: CKRecord.ID
    let type: MediaType
    
    let title: String
    let creationDate: Date

    // Video-related
    let videoURL: URL?

    // Photo-related
    let imageURL: URL?

    init(record: CKRecord, type: MediaType) {
        self.id = record.recordID
        self.type = type
        
        // Common fields
        self.title = record["title"] as? String ?? ""
        self.creationDate = record.creationDate ?? Date()
        
        // Video fields
        if type == .video {
            let videoAsset = record["videoURL"] as? CKAsset
            self.videoURL = videoAsset?.fileURL
            
            self.imageURL = nil
        }
        // Photo fields
        else {
            self.imageURL = (record["imageURL"] as? CKAsset)?.fileURL
            self.videoURL = nil
        }
    }
}
