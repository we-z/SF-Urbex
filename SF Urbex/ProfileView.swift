//
//  ProfileView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 12/30/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var cloudKitManager = CloudKitManager()
    @State private var showUploadSheet = false
    @State private var feed = 0

    var body: some View {
        NavigationView {
            VStack{
                ScrollView {
                    VStack{
                        Circle()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.secondary.opacity(0.3))
                            .padding()
                        Text("Anon.Urbexer")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        Text("Exploring the urban world. Capturing the moments that matter most.")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .padding()
                    LazyVStack {
                        ForEach(cloudKitManager.mediaItems) { item in
                            MyPost(item: item)
                                .padding(.vertical)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            print("Pressed")
                        } label: {
                            Text("Edit")
                                .font(.title2)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("Pressed")
                        } label: {
                            Image(systemName: "gear")
                                .font(.title3)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Picker("", selection: $feed) {
                            Text("Public").tag(0)
                            Text("Private").tag(1)
                        }
                        .frame(width: 180)
                        .pickerStyle(SegmentedPickerStyle())
                        
                    }
                }
                .refreshable {
                    cloudKitManager.fetchAllMedia()
                }
                .onAppear {
                    cloudKitManager.fetchAllMedia()
                }
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MyPost: View {
    let item: MediaItem
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.secondary)
                    .opacity(0.3)
                if let imageURL = item.imageURL,
                    let uiImage = loadUIImage(from: imageURL) {
                    let isLandscape = uiImage.size.width < uiImage.size.height
                    NavigationLink(destination: isLandscape ? FullImageView(uiImage: uiImage) : FullImageView(uiImage: flipUIImage(uiImage))) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                } else {
                    ProgressView()
                }
            }
            .aspectRatio(contentMode: .fit)
            .cornerRadius(30)
        }
        .padding([.horizontal, .top])
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
    ProfileView()
}
