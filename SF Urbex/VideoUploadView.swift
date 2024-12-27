import SwiftUI
import PhotosUI
import AVKit

struct UploadMediaView: View {
    @ObservedObject var cloudKitManager: CloudKitManager = CloudKitManager()

    // We will detect if it's a video or an image automatically
    @State private var isVideoSelected = false

    @State private var videoURL: URL?
    @State private var imageURL: URL?

    @State private var showPicker = false
    @State private var isSelectingMedia = false
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                Button("Select Media") {
                    showPicker = true
                }
                .padding()

                if isSelectingMedia {
                    ProgressView("Selecting Media...")
                        .padding()
                } else {
                    selectedMediaPreview
                        .frame(height: 200)
                        .cornerRadius(15)
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
            return (videoURL == nil)
        } else {
            return (imageURL == nil)
        }
    }

    @ViewBuilder
    private var selectedMediaPreview: some View {
        if isVideoSelected, let videoURL = videoURL {
            Rectangle()
                .foregroundColor(.secondary)
                .opacity(0.3)
                .aspectRatio(contentMode: .fill)
                .overlay(
                    VideoPlayer(player: AVPlayer(url: videoURL))
                )
                .cornerRadius(30)
        } else if let imageURL = imageURL {
            Rectangle()
                .foregroundColor(.secondary)
                .opacity(0.3)
                .aspectRatio(contentMode: .fill)
                .overlay(
                    AsyncImage(url: imageURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                )
                .cornerRadius(30)
        } else {
            EmptyView()
        }
    }

    private func uploadMedia() {
        if isVideoSelected, let videoURL = videoURL {
            cloudKitManager.uploadVideo(videoURL: videoURL) { progress in
                DispatchQueue.main.async {
                    uploadProgress = progress
                }
            } completion: {
                DispatchQueue.main.async {
                    isUploading = false
                    uploadProgress = 0.0
                }
            }
        } else if let imageURL = imageURL {
            cloudKitManager.uploadImage(imageURL: imageURL) { progress in
                DispatchQueue.main.async {
                    uploadProgress = progress
                }
            } completion: {
                DispatchQueue.main.async {
                    isUploading = false
                    uploadProgress = 0.0
                }
            }
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

#Preview {
    UploadMediaView()
}
