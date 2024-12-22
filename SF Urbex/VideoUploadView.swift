//
//  VideoUploadView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import PhotosUI

struct VideoUploadView: View {
    @State private var selectedVideoItem: PhotosPickerItem? = nil
    @State private var selectedVideoURL: URL? = nil
    @State private var caption: String = ""
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: VideoFeedViewModel

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedVideoItem,
                matching: .videos,
                label: {
                    Text("Select Video")
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            )
            .onChange(of: selectedVideoItem) { newItem in
                Task {
                    if let newItem = newItem {
                        if let videoURL = try? await newItem.loadTransferable(type: URL.self) {
                            selectedVideoURL = videoURL
                        } else {
                            print("Failed to load video URL")
                        }
                    }
                }
            }

            if let videoURL = selectedVideoURL {
                Text("Selected Video: \(videoURL.lastPathComponent)")
            }

            TextField("Enter Caption", text: $caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Upload") {
                if let videoURL = selectedVideoURL {
                    viewModel.uploadVideo(videoURL: videoURL, caption: caption)
                    dismiss()
                }
            }
            .disabled(selectedVideoURL == nil || caption.isEmpty)
            .padding()
        }
        .padding()
    }
}
