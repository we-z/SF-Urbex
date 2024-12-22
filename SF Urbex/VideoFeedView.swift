//
//  VideoFeedView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import AVKit

struct VideoFeedView: View {
    @StateObject private var viewModel = VideoFeedViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.videoPosts) { post in
                        VideoPostView(videoPost: post)
                    }
                }
            }
            .onAppear {
                viewModel.fetchVideoPosts()
            }
            .navigationTitle("SF Urbex")
//            .toolbar {
//                NavigationLink("Upload", destination: VideoUploadView(viewModel: viewModel))
//            }
        }
    }
}

struct VideoPostView: View {
    let videoPost: VideoPost

    var body: some View {
        VStack {
            VideoPlayer(player: AVPlayer(url: videoPost.videoURL))
                .frame(height: 300)
            Text(videoPost.caption)
                .padding()
        }
        .padding()
    }
}


#Preview {
    VideoFeedView()
}
