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
                LazyVStack {
                    ForEach(cloudKitManager.videos) { video in
                        VStack {
                            Text(video.title)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                                .padding()
                            NavigationLink(destination: VideoPlayerView(videoURL: video.videoURL)) {
                                GeometryReader { geometry in
                                    AsyncImage(url: video.thumbnailURL) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                                    .clipShape(RoundedRectangle(cornerRadius: geometry.size.width / 9))
                                }
                                .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
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
            .onDisappear {
                AVPlayer(url: videoURL).pause()
            }
    }
}

#Preview {
    VideoFeedView()
}
