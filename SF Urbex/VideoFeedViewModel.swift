//
//  VideoFeedViewModel.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import Foundation
import CloudKit

class VideoFeedViewModel: ObservableObject {
    @Published var videoPosts: [VideoPost] = []

    private let publicDatabase = CKContainer.default().publicCloudDatabase

    func fetchVideoPosts() {
        let query = CKQuery(recordType: "VideoPost", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        publicDatabase.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching video posts: \(error)")
                    return
                }
                self.videoPosts = records?.compactMap { VideoPost(record: $0) } ?? []
            }
        }
    }

    func uploadVideo(videoURL: URL, caption: String) {
        let record = VideoPost.createRecord(videoURL: videoURL, caption: caption)
        publicDatabase.save(record) { _, error in
            if let error = error {
                print("Error uploading video: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.fetchVideoPosts()
                }
            }
        }
    }
}
