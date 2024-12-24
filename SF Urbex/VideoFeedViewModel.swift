//
//  CloudKitManager.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import Foundation
import CloudKit

class CloudKitManager: ObservableObject {
    @Published var mediaItems: [MediaItem] = []
    
    private let database = CKContainer.default().publicCloudDatabase
    
    // MARK: - Combined Fetch
    func fetchAllMedia() {
        // We perform two queries: one for Video, one for Photo.
        // Then we merge the results, sort, and publish them.
        fetchVideos { videoItems in
            self.fetchPhotos { photoItems in
                // Merge
                let combined = videoItems + photoItems
                // Sort descending by creation date
                let sorted = combined.sorted { $0.creationDate > $1.creationDate }
                
                DispatchQueue.main.async {
                    self.mediaItems = sorted
                }
            }
        }
    }
    
    // MARK: - Fetch Videos
    private func fetchVideos(completion: @escaping ([MediaItem]) -> Void) {
        let query = CKQuery(recordType: "Video", predicate: NSPredicate(value: true))
        // Sort by creationDate descending (optional if you want to rely on local sorting)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                print("Error fetching videos: \(error?.localizedDescription ?? "Unknown")")
                completion([])
                return
            }
            
            let items = records.map { record in
                MediaItem(record: record, type: .video)
            }
            completion(items)
        }
    }
    
    // MARK: - Fetch Photos
    private func fetchPhotos(completion: @escaping ([MediaItem]) -> Void) {
        let query = CKQuery(recordType: "Photo", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                print("Error fetching photos: \(error?.localizedDescription ?? "Unknown")")
                completion([])
                return
            }
            
            let items = records.map { record in
                MediaItem(record: record, type: .photo)
            }
            completion(items)
        }
    }
    
    // MARK: - Upload Video
    func uploadVideo(title: String, videoURL: URL, thumbnailURL: URL) {
        let record = CKRecord(recordType: "Video")
        record["title"] = title as CKRecordValue
        record["videoURL"] = CKAsset(fileURL: videoURL)
        record["thumbnailURL"] = CKAsset(fileURL: thumbnailURL)

        database.save(record) { _, error in
            if let error = error {
                print("Error uploading video: \(error.localizedDescription)")
            } else {
                print("Video uploaded successfully!")
                // Refresh feed
                self.fetchAllMedia()
            }
        }
    }
    
    // MARK: - Upload Image
    func uploadImage(title: String, imageURL: URL) {
        let record = CKRecord(recordType: "Photo")
        record["title"] = title as CKRecordValue
        record["imageURL"] = CKAsset(fileURL: imageURL)
        
        database.save(record) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully!")
                // Refresh feed
                self.fetchAllMedia()
            }
        }
    }
}
