//
//  CloudKitManager.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import Foundation
import CloudKit

class CloudKitManager: ObservableObject {
    @Published var mediaItems: [MediaItem] = [
            MediaItem(
                record: CKRecord(recordType: "Placeholder"),
                type: .photo
            ),
            MediaItem(
                record: CKRecord(recordType: "Placeholder"),
                type: .video
            )
        ]
    
    private let database = CKContainer.default().publicCloudDatabase
    
    // MARK: - Combined Fetch
    func fetchAllMedia() {
        fetchVideos { videoItems in
            self.fetchPhotos { photoItems in
                let combined = videoItems + photoItems
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
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        var videoItems: [MediaItem] = []
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                let item = MediaItem(record: record, type: .video)
                videoItems.append(item)
            case .failure(let error):
                print("Error fetching video record \(recordID): \(error.localizedDescription)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                completion(videoItems)
            case .failure(let error):
                print("Error completing video query: \(error.localizedDescription)")
                completion(videoItems)
            }
        }
        
        database.add(operation)
    }
    
    // MARK: - Fetch Photos
    private func fetchPhotos(completion: @escaping ([MediaItem]) -> Void) {
        let query = CKQuery(recordType: "Photo", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        var photoItems: [MediaItem] = []
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                let item = MediaItem(record: record, type: .photo)
                photoItems.append(item)
            case .failure(let error):
                print("Error fetching photo record \(recordID): \(error.localizedDescription)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                completion(photoItems)
            case .failure(let error):
                print("Error completing photo query: \(error.localizedDescription)")
                completion(photoItems)
            }
        }
        
        database.add(operation)
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
                self.fetchAllMedia()
            }
        }
    }
}
