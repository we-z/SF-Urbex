//
//  VideoUploadView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import PhotosUI

struct UploadVideoView: View {
    @ObservedObject var cloudKitManager: CloudKitManager
    @State private var videoURL: URL?
    @State private var thumbnailURL: URL?
    @State private var title: String = ""
    @State private var showPicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Video Details")) {
                    TextField("Title", text: $title)
                    Button("Select Video") {
                        showPicker = true
                    }
                    if let videoURL = videoURL {
                        Text("Selected: \(videoURL.lastPathComponent)")
                    }
                }
                Button("Upload") {
                    if let videoURL = videoURL, let thumbnailURL = thumbnailURL {
                        cloudKitManager.uploadVideo(title: title, videoURL: videoURL, thumbnailURL: thumbnailURL)
                    }
                }
            }
            .navigationTitle("Upload Video")
        }
    }
}

#Preview {
    ContentView()
}
