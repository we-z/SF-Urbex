//
//  MediaFeedView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import AVKit

struct MediaFeedView: View {
    @StateObject private var cloudKitManager = CloudKitManager()
    @State private var showUploadSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(cloudKitManager.mediaItems) { item in
                        MediaCard(item: item)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Hush Post")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Pressed")
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                }
            }
            .refreshable {
                cloudKitManager.fetchAllMedia()
            }
            .onAppear {
                cloudKitManager.fetchAllMedia()
            }
        }
        .accentColor(.primary)
    }
}

// MARK: - Subview for Each MediaItem
struct MediaCard: View {
    let item: MediaItem
    
    var body: some View {
        VStack {
            // Title row
            HStack {
                Circle()
                    .foregroundColor(.secondary)
                    .opacity(0.3)
                    .overlay(
                        AsyncImage(url: item.imageURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            EmptyView()
                        }
                    )
                    .frame(width: 40, height: 40)
                    .cornerRadius(30)
                Text("Anon.Urbexer")
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            NavigationLink(destination: FullImageView(imageURL: item.imageURL)) {
                Rectangle()
                    .foregroundColor(.secondary)
                    .opacity(0.3)
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        AsyncImage(url: item.imageURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    )
                    .cornerRadius(30)
            }
        }
        .padding([.horizontal, .top])
    }
}

// MARK: - Full Image View
struct FullImageView: View {
    let imageURL: URL?

    var body: some View {
        GeometryReader { geometry in
            if let imageURL = imageURL,
               let uiImage = loadUIImage(from: imageURL) {
                let isLandscape = uiImage.size.width > uiImage.size.height

                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(isLandscape ? .degrees(90) : .degrees(0))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
            } else {
                ProgressView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
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
    MediaFeedView()
}
