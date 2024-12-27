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
                    .foregroundColor(.secondary)
                    .opacity(0.3)
                    .frame(width: 40, height: 40)
                Text(item.title)
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            switch item.type {
            case .video:
                Rectangle()
                    .foregroundColor(.secondary)
                    .opacity(0.3)
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        Group {
                            if let videoURL = item.videoURL {
                                VideoPlayer(player: AVPlayer(url: videoURL))
                                    .scaledToFill()
                            } else {
                                ProgressView()
                            }
                        }
                    )
                    .cornerRadius(30)
            case .photo:
                Rectangle()
                    .foregroundColor(.secondary)
                    .opacity(0.3)
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        AsyncImage(url: item.imageURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    )
                    .cornerRadius(30)
            }
        }
    }
}

#Preview {
    MediaFeedView()
}
