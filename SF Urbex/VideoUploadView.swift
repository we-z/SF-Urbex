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
                    if imageURL == nil {
                        showPicker = true
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.secondary)
                            .opacity(0.3)
                            .overlay{
                                VStack {
                                    if imageURL == nil {
                                        Image(systemName: "plus")
                                            .font(.largeTitle)
                                            .padding()
                                        Text("Select Photo")
                                            .bold()
                                            .font(.title2)
                                    }
                                }
                            }
                        if let imageURL = imageURL, let uiImage = loadUIImage(from: imageURL) {
                            let isLandscape = uiImage.size.width < uiImage.size.height
                            NavigationLink(destination: isLandscape ? FullImageView(uiImage: uiImage) : FullImageView(uiImage: flipUIImage(uiImage))) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                            
                    }
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
                    .padding()
                    
                }

                Spacer()

                if imageURL != nil {
                    HStack {
                        Spacer()
                        Button {
                            imageURL = nil
                        } label: {
                            HStack {
                                Spacer()
                                Text("Cancel")
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                Spacer()
                            }
                            .background(Color.red)
                            .cornerRadius(12)
                        }
                        Spacer()
                        Button {
                            isUploading = true
                            uploadMedia()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Share")
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                Spacer()
                            }
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        Spacer()
                    }
                    .padding()
                }

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
    
    private func flipUIImage(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: image.size.height, height: image.size.width))
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: image.size.height / 2, y: image.size.width / 2)
            context.rotate(by: .pi / 2)
            image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        }
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage ?? image
    }

    private func loadUIImage(from url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            return uiImage
        }
        return nil
    }
}
struct MediaPicker: UIViewControllerRepresentable {
    
    @Binding var imageURL: URL?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images]) // Only images
        config.selectionLimit = 1           // Single selection
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // No updates needed here.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MediaPicker

        init(parent: MediaPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // If no selection was made, just dismiss
            guard let provider = results.first?.itemProvider else {
                picker.dismiss(animated: true)
                return
            }

            // Reset parent image to nil until confirmed
            parent.imageURL = nil

            // Check if we can load a UIImage
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        guard let uiImage = image as? UIImage else {
                            picker.dismiss(animated: true)
                            return
                        }

                        // --- Present the confirmation screen ---
                        let confirmationView = ImageConfirmationView(
                            uiImage: uiImage,
                            onConfirm: {
                                // When confirmed, write to a temporary file, update parent, and dismiss
                                if let jpegData = uiImage.jpegData(compressionQuality: 1.0) {
                                    let tempURL = FileManager.default.temporaryDirectory
                                        .appendingPathComponent(UUID().uuidString + ".jpg")
                                    do {
                                        try jpegData.write(to: tempURL)
                                        self.parent.imageURL = tempURL
                                        picker.dismiss(animated: true)
                                    } catch {
                                        print("Error saving image: \(error.localizedDescription)")
                                    }
                                }
                                picker.dismiss(animated: true)
                            }
                        )

                        // Present the SwiftUI confirmation view in a UIHostingController
                        let hostingController = UIHostingController(rootView: confirmationView)
                        
                        // Present on top of the picker
                        picker.present(hostingController, animated: true)
                    }
                }
            } else {
                // If no valid image was found, just dismiss
                picker.dismiss(animated: true)
            }
        }
    }
}

struct ImageConfirmationView: View {
    let uiImage: UIImage
    let onConfirm: () -> Void
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 20) {
            Text("Confirm Your Image")
                .font(.headline)
                .padding()

            Spacer()
            
            // Show the selected image
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            HStack {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(9)
                }
                .accentColor(.primary)

                Button {
                    onConfirm()
                } label: {
                    Text("Confirm")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(9)
                }
                .accentColor(.primary)
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
