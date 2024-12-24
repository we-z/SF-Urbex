//
//  UploadMediaView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import PhotosUI

struct UploadMediaView: View {
    @ObservedObject var cloudKitManager: CloudKitManager
    
    // We will detect if it's a video or an image automatically
    @State private var isVideoSelected = false
    
    @State private var videoURL: URL?
    @State private var thumbnailURL: URL?
    @State private var imageURL: URL?
    
    @State private var title: String = ""
    @State private var showPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Upload Details")) {
                    TextField("Title", text: $title)

                    Button("Select Media") {
                        showPicker = true
                    }
                    
                    if isVideoSelected, let videoURL = videoURL {
                        Text("Selected Video: \(videoURL.lastPathComponent)")
                    } else if !isVideoSelected, let imageURL = imageURL {
                        Text("Selected Image: \(imageURL.lastPathComponent)")
                    }
                }
                
                Button("Upload") {
                    if isVideoSelected {
                        if let videoURL = videoURL, let thumbnailURL = thumbnailURL {
                            cloudKitManager.uploadVideo(title: title,
                                                        videoURL: videoURL,
                                                        thumbnailURL: thumbnailURL)
                        }
                    } else {
                        if let imageURL = imageURL {
                            cloudKitManager.uploadImage(title: title,
                                                        imageURL: imageURL)
                        }
                    }
                }
                .disabled(shouldDisableUploadButton)
            }
            .navigationTitle("Upload Media")
        }
        .sheet(isPresented: $showPicker) {
            MediaPicker(isVideoSelected: $isVideoSelected,
                        videoURL: $videoURL,
                        thumbnailURL: $thumbnailURL,
                        imageURL: $imageURL)
        }
    }
    
    private var shouldDisableUploadButton: Bool {
        // If it's a video, we need both the video and thumbnail plus a non-empty title
        // If it's an image, we just need image plus a non-empty title
        if isVideoSelected {
            return (videoURL == nil || thumbnailURL == nil || title.isEmpty)
        } else {
            return (imageURL == nil || title.isEmpty)
        }
    }
}

//
//  MediaPicker.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import AVFoundation

struct MediaPicker: UIViewControllerRepresentable {
    @Binding var isVideoSelected: Bool
    
    @Binding var videoURL: URL?
    @Binding var thumbnailURL: URL?
    @Binding var imageURL: URL?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        // Allow picking images or videos
        config.filter = .any(of: [.images, .videos])
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MediaPicker

        init(_ parent: MediaPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            
            // Clear out any prior selections
            parent.videoURL = nil
            parent.thumbnailURL = nil
            parent.imageURL = nil
            
            // Check if the user selected a video
            if provider.hasItemConformingToTypeIdentifier("public.movie") {
                parent.isVideoSelected = true
                provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                    guard let url = url else { return }
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                    do {
                        try FileManager.default.copyItem(at: url, to: tempURL)
                        DispatchQueue.main.async {
                            self.parent.videoURL = tempURL
                            // Generate a thumbnail
                            self.parent.thumbnailURL = self.generateThumbnail(from: tempURL)
                        }
                    } catch {
                        print("Error copying video: \(error.localizedDescription)")
                    }
                }
            }
            // Otherwise, check for an image
            else if provider.canLoadObject(ofClass: UIImage.self) {
                parent.isVideoSelected = false
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        guard let uiImage = image as? UIImage else { return }
                        // Save the image to temp directory
                        if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
                            let tempURL = FileManager.default.temporaryDirectory
                                .appendingPathComponent(UUID().uuidString + ".jpg")
                            do {
                                try jpegData.write(to: tempURL)
                                self.parent.imageURL = tempURL
                            } catch {
                                print("Error saving image: \(error.localizedDescription)")
                            }
                        }
                    }
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
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent("thumbnail-\(UUID().uuidString).jpg")
                try uiImage.jpegData(compressionQuality: 0.8)?.write(to: tempURL)
                return tempURL
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
