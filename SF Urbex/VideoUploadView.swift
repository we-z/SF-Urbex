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
        .sheet(isPresented: $showPicker) {
            VideoPicker(videoURL: $videoURL, thumbnailURL: $thumbnailURL)
        }
    }
}

#Preview {
    ContentView()
}

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
