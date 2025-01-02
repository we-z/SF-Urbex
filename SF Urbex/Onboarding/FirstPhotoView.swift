//
//  FirstPhotoView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/2/25.
//

import SwiftUI

struct FirstPhotoView: View {
    @ObservedObject var cloudKitManager: CloudKitManager = CloudKitManager()
    @State private var navigateToProfilePreview = false

    @State private var imageURL: URL?

    @State private var showPicker = false
    @State private var isSelectingMedia = false
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading = false
    
    @State private var visibility = 0

    var body: some View {
            
        VStack {
            if isUploading {
                ProgressView(value: uploadProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
            }
            Spacer()
            ScrollView {
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
                
                HStack {
                    Spacer()
                    Button {
                        imageURL = nil
                    } label: {
                        HStack {
                            Spacer()
                            Text("Cancel")
                                .bold()
                                .font(.title2)
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
                                .font(.title2)
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
                .opacity(imageURL == nil ? 0.5 : 1)
                .disabled(imageURL == nil)
            }
            .scrollIndicators(.hidden)
            NavigationLink(destination: ProfilePreviewView(), isActive: $navigateToProfilePreview) {
                EmptyView()
            }
            NavigationLink(destination: ProfilePreviewView()) {
                Text("Next")
                    .bold()
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding()
            }
        }
        .navigationTitle("Share First Photo")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("", selection: $visibility) {
                    Text("Public").tag(0)
                    Text("Private").tag(1)
                }
                .frame(width: 210)
                .pickerStyle(SegmentedPickerStyle())
                
            }
        }
        .sheet(isPresented: $showPicker) {
            MediaPicker(imageURL: $imageURL)
                .onAppear {
                    isSelectingMedia = true
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    isUploading = false
                    uploadProgress = 0.0
                    imageURL = nil
                    navigateToProfilePreview = true
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

#Preview {
    NavigationView {
        FirstPhotoView()
    }
}
