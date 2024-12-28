import SwiftUI
import PhotosUI
import AVKit

struct UploadMediaView: View {
    @ObservedObject var cloudKitManager: CloudKitManager = CloudKitManager()
    @Binding var selectedTab: Int

    @State private var imageURL: URL?

    @State private var showPicker = false
    @State private var isSelectingMedia = false
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Button {
                    if (imageURL == nil) {
                        showPicker = true
                    }
                } label: {
                    Rectangle()
                        .foregroundColor(.secondary)
                        .opacity(0.3)
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            AsyncImage(url: imageURL) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                VStack {
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .padding()
                                    Text("Select Photo")
                                }
                            }
                        )
                        .cornerRadius(30)
                    
                }
                .accentColor(.primary)
                .padding()
                if (imageURL != nil) {
                    HStack {
                        Spacer()
                        Button {
                            imageURL = nil
                        } label: {
                            HStack {
                                Spacer()
                                Text("Cancel")
                                    .padding()
                                Spacer()
                            }
                                .background(.secondary.opacity(0.3))
                                .cornerRadius(12)
                        }
                        .accentColor(.primary)
                        Spacer()
                        Button {
                            showPicker = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Change Photo")
                                    .padding()
                                Spacer()
                            }
                                .background(.secondary.opacity(0.3))
                                .cornerRadius(12)
                        }
                        .accentColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                Spacer()

                Button {
                    isUploading = true
                    uploadMedia()
                } label: {
                    HStack{
                        Spacer()
                        Text("Share")
                            .font(.title2)
                            .padding()
                        Spacer()
                    }
                    .background(.secondary.opacity(0.3))
                    .cornerRadius(12)
                    .padding()
                }
                .accentColor(.primary)
                .disabled(shouldDisableUploadButton)

                if isUploading {
                    ProgressView(value: uploadProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                }
            }
            .navigationTitle("Share Photo")
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

    private func uploadMedia() {
        if let imgURL = imageURL {
            cloudKitManager.uploadImage(imageURL: imgURL) { progress in
                DispatchQueue.main.async {
                    uploadProgress = progress
                }
            } completion: {
                DispatchQueue.main.async {
                    isUploading = false
                    uploadProgress = 0.0
                    imageURL = nil
                    selectedTab = 0 // Switch to MediaFeedView tab
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
