//
//  VideoFeedViewModel.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import Foundation
import CloudKit

class CloudKitManager: ObservableObject {
    @Published var videos: [Video] = []
    private let database = CKContainer.default().publicCloudDatabase

    func fetchVideos() {
        let query = CKQuery(recordType: "Video", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                print("Error fetching videos: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.videos = records.map { record in
                    Video(
                        id: record.recordID.recordName,
                        title: record["title"] as? String ?? "",
                        videoURL: (record["videoURL"] as? CKAsset)?.fileURL ?? URL(fileURLWithPath: ""),
                        thumbnailURL: (record["thumbnailURL"] as? CKAsset)?.fileURL ?? URL(fileURLWithPath: ""),
                        recordID: record.recordID
                    )
                }
            }
        }
    }

    func uploadVideo(title: String, videoURL: URL, thumbnailURL: URL) {
        let record = CKRecord(recordType: "Video")
        record["title"] = title as CKRecordValue
        record["videoURL"] = CKAsset(fileURL: videoURL)
        record["thumbnailURL"] = CKAsset(fileURL: thumbnailURL)

        database.save(record) { record, error in
            if let error = error {
                print("Error uploading video: \(error.localizedDescription)")
            } else {
                print("Video uploaded successfully!")
            }
        }
    }
}
