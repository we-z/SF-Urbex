import SwiftUI
import PhotosUI

struct UploadMediaView: View {
    @ObservedObject var cloudKitManager: CloudKitManager

    // We will detect if it's a video or an image automatically
    @State private var isVideoSelected = false

    @State private var videoURL: URL?
    @State private var imageURL: URL?

    @State private var title: String = ""
    @State private var showPicker = false
    @State private var isSelectingMedia = false
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Select Media") {
                    showPicker = true
                }
                .padding()

                if isSelectingMedia {
                    ProgressView("Selecting Media...")
                        .padding()
                } else if isVideoSelected, let videoURL = videoURL {
                    Text("Selected Video: \(videoURL.lastPathComponent)")
                        .padding()
                } else if !isVideoSelected, let imageURL = imageURL {
                    Text("Selected Image: \(imageURL.lastPathComponent)")
                        .padding()
                }

                Button("Upload") {
                    isUploading = true
                    uploadMedia()
                }
                .padding()
                .disabled(shouldDisableUploadButton)

                if isUploading {
                    ProgressView(value: uploadProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("Upload Media")
            .sheet(isPresented: $showPicker) {
                MediaPicker(isVideoSelected: $isVideoSelected, videoURL: $videoURL, imageURL: $imageURL)
                    .onChange(of: isVideoSelected) { _ in
                        isSelectingMedia = false
                    }
                    .onAppear {
                        isSelectingMedia = true
                    }
            }
        }
    }

    private var shouldDisableUploadButton: Bool {
        if isVideoSelected {
            return (videoURL == nil || title.isEmpty)
        } else {
            return (imageURL == nil || title.isEmpty)
        }
    }

    private func uploadMedia() {
        if isVideoSelected, let videoURL = videoURL {
            cloudKitManager.uploadVideo(title: title, videoURL: videoURL, progress: { progress in
                DispatchQueue.main.async {
                    uploadProgress = progress
                }
            }, completion: {
                DispatchQueue.main.async {
                    isUploading = false
                    uploadProgress = 0.0
                }
            })
        } else if let imageURL = imageURL {
            cloudKitManager.uploadImage(title: title, imageURL: imageURL, progress: { progress in
                DispatchQueue.main.async {
                    uploadProgress = progress
                }
            }, completion: {
                DispatchQueue.main.async {
                    isUploading = false
                    uploadProgress = 0.0
                }
            })
        }
    }

}

struct MediaPicker: UIViewControllerRepresentable {
    @Binding var isVideoSelected: Bool
    
    @Binding var videoURL: URL?
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

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MediaPicker

        init(_ parent: MediaPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            
            parent.videoURL = nil
            parent.imageURL = nil
            
            if provider.hasItemConformingToTypeIdentifier("public.movie") {
                parent.isVideoSelected = true
                provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                    guard let url = url else { return }
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
                    do {
                        try FileManager.default.copyItem(at: url, to: tempURL)
                        DispatchQueue.main.async {
                            self.parent.videoURL = tempURL
                        }
                    } catch {
                        print("Error copying video: \(error.localizedDescription)")
                    }
                }
            } else if provider.canLoadObject(ofClass: UIImage.self) {
                parent.isVideoSelected = false
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        guard let uiImage = image as? UIImage else { return }
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
    }
}
