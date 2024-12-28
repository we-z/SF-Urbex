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
                record: CKRecord(recordType: "Placeholder")
            ),
            MediaItem(
                record: CKRecord(recordType: "Placeholder")
            )
        ]
    
    private let database = CKContainer.default().publicCloudDatabase
    
    // MARK: - Combined Fetch
    func fetchAllMedia() {
        self.fetchPhotos { photoItems in
            let combined = photoItems
            let sorted = combined.sorted { $0.creationDate > $1.creationDate }
            
            DispatchQueue.main.async {
                self.mediaItems = sorted
            }
        }
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
                let item = MediaItem(record: record)
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

        func uploadImage(imageURL: URL, progress: @escaping (Double) -> Void, completion: @escaping () -> Void) {
            let record = CKRecord(recordType: "Photo")
            record["imageURL"] = CKAsset(fileURL: imageURL)

            DispatchQueue.global(qos: .background).async {
                // Simulate progress
                for i in 1...10 {
                    DispatchQueue.main.async {
                        progress(Double(i) / 10.0)
                    }
                    Thread.sleep(forTimeInterval: 0.1) // Simulate upload delay
                }

                self.database.save(record) { _, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error uploading image: \(error.localizedDescription)")
                        } else {
                            print("Image uploaded successfully!")
                            self.fetchAllMedia()
                        }
                        completion()
                    }
                }
            }
        }
}
