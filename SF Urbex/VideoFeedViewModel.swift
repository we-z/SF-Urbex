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

    func uploadImage(
            imageURL: URL,
            progress: @escaping (Double) -> Void,
            completion: @escaping () -> Void
        ) {
            // Create the CKRecord and attach the CKAsset
            let record = CKRecord(recordType: "Photo")
            record["imageURL"] = CKAsset(fileURL: imageURL)

            // Create a CKModifyRecordsOperation
            let saveOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            saveOperation.savePolicy = .changedKeys
            
            // Called with a progress value (0.0 - 1.0) as each record is uploaded
            saveOperation.perRecordProgressBlock = { record, progressValue in
                DispatchQueue.main.async {
                    progress(progressValue)
                }
            }
            
            // Called when each record finishes uploading
            saveOperation.perRecordCompletionBlock = { record, error in
                if let error = error {
                    print("Error completing upload for \(record.recordID): \(error.localizedDescription)")
                }
            }
            
            // Called when the operation (for all records) is complete
            saveOperation.modifyRecordsResultBlock = { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("Image uploaded successfully!")
                        // Refresh your local media items
                        self.fetchAllMedia()
                    case .failure(let error):
                        print("Error uploading image: \(error.localizedDescription)")
                    }
                    completion()
                }
            }
            
            // Add the operation to the database
            database.add(saveOperation)
        }
}
