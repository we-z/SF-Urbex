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
                GeometryReader { geometry in
                LazyVStack {
                    ForEach(cloudKitManager.videos) { video in
                        
                            VStack {
                                HStack {
                                    Circle()
                                        .foregroundColor(.gray)
                                        .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                                    Text(video.title)
                                        .font(.system(size: geometry.size.width / 18))
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                .padding(.leading)
                                NavigationLink(destination: VideoPlayerView(videoURL: video.videoURL)) {
                                
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
