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
                List(cloudKitManager.videos) { video in
                    NavigationLink(destination: VideoPlayerView(videoURL: video.videoURL)) {
                        HStack {
                            AsyncImage(url: video.thumbnailURL) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text(video.title)
                                .font(.headline)
                                .padding(.leading, 8)
                        }
                    }
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
            .aspectRatio(contentMode: .fit)
            .onDisappear {
                AVPlayer(url: videoURL).pause()
            }
    }
}

#Preview {
    VideoFeedView()
}
