//
//  MediaFeedView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import AVKit

struct MediaFeedView: View {
    @StateObject private var cloudKitManager = CloudKitManager()
    @State private var showUploadSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(cloudKitManager.mediaItems) { item in
                        MediaCard(item: item)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Hush Post")
            .refreshable {
                cloudKitManager.fetchAllMedia()
            }
            .onAppear {
                // Fetch both videos and photos
                cloudKitManager.fetchAllMedia()
            }
        }
        .accentColor(.primary)
    }
}

// MARK: - Subview for Each MediaItem
struct MediaCard: View {
    let item: MediaItem
    
    var body: some View {
        VStack {
            // Title row
            HStack {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 40)
                Text(item.title)
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            switch item.type {
            case .video:
//                NavigationLink(destination: VideoPlayerView(videoURL: item.videoURL!)) {
                    // Display thumbnail
                    if let thumbURL = item.thumbnailURL {
                        Rectangle()
                            .foregroundColor(.secondary)
                            .aspectRatio(contentMode: .fill)
                            .overlay(
                                AsyncImage(url: thumbURL) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            )
                            .cornerRadius(30)
                    }
//                }
            case .photo:
//                NavigationLink(destination: PhotoDetailView(imageURL: item.imageURL!)) {
                    if let imgURL = item.imageURL {
                        Rectangle()
                            .foregroundColor(.secondary)
                            .aspectRatio(contentMode: .fill)
                            .overlay(
                                AsyncImage(url: imgURL) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            )
                            .cornerRadius(30)
                    }
//                }
            }
        }
    }
}

// MARK: - VideoPlayerView
struct VideoPlayerView: View {
    let videoURL: URL

    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .onDisappear {
                // Pause the player when leaving
                AVPlayer(url: videoURL).pause()
            }
            .navigationTitle("Video Player")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - PhotoDetailView
struct PhotoDetailView: View {
    let imageURL: URL

    var body: some View {
        VStack {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
        }
    }
}

#Preview {
    MediaFeedView()
}
