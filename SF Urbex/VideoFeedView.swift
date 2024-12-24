//
//  VideoFeedView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import AVKit
import PhotosUI

struct VideoFeedView: View {
    @StateObject private var cloudKitManager = CloudKitManager()
    @State private var showUploadSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                    ForEach(cloudKitManager.videos) { video in
                        NavigationLink(destination: VideoPlayerView(videoURL: video.videoURL)) {
                            VStack {
                                Text(video.title)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .padding()
                                GeometryReader { geometry in
                                    AsyncImage(url: video.thumbnailURL) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .aspectRatio(1, contentMode: .fit)
                                
                                
                            }
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                cloudKitManager.fetchVideos()
            }
            .navigationTitle("Home")
        }
    }
}

struct VideoPlayerView: View {
    let videoURL: URL

    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
//            .aspectRatio(contentMode: .fit)
            .onDisappear {
                AVPlayer(url: videoURL).pause()
            }
    }
}

#Preview {
    VideoFeedView()
}
