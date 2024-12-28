import SwiftUI
import PhotosUI
import AVKit

struct UploadMediaView: View {
    @ObservedObject var cloudKitManager: CloudKitManager = CloudKitManager()

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

//                if isSelectingMedia {
//                    ProgressView("Selecting Media...")
//                        .padding()
//                } else {
                    selectedMediaPreview
//                        .frame(height: 200)
//                        .cornerRadius(15)
//                        .padding()
//                }

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
                MediaPicker(imageURL: $imageURL)
                    .onAppear {
                        isSelectingMedia = true
                    }
            }
        }
    }

    private var shouldDisableUploadButton: Bool {
        return (imageURL == nil)
    }

    @ViewBuilder
    private var selectedMediaPreview: some View {
        if let imageURL = imageURL {
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
        }
    }

    private func uploadMedia() {
        if let imageURL = imageURL {
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
    
    @Binding var imageURL: URL?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images])
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
            
            parent.imageURL = nil
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                print("image selected")
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
