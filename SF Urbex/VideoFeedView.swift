//
//  VideoFeedView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import AVKit

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
                .navigationTitle("SF Urbex")

            }

        }
}


import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var videoURL: URL?
    @Binding var thumbnailURL: URL?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.hasItemConformingToTypeIdentifier("public.movie") else { return }

            provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                guard let url = url else { return }
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.copyItem(at: url, to: tempURL)
                DispatchQueue.main.async {
                    self.parent.videoURL = tempURL
                    self.parent.thumbnailURL = self.generateThumbnail(from: tempURL)
                }
            }
        }

        private func generateThumbnail(from url: URL) -> URL? {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            do {
                let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                let uiImage = UIImage(cgImage: cgImage)
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("thumbnail.jpg")
                try uiImage.jpegData(compressionQuality: 0.8)?.write(to: tempURL)
                return tempURL
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                return nil
            }
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
