//
//  MediaFeedView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI
import UIKit
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
                    .frame(width: 40, height: 40)
                    .cornerRadius(30)
                Text("Anon.Urbexer")
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            
                ZStack {
                    Rectangle()
                        .foregroundColor(.secondary)
                        .opacity(0.3)
                    if let imageURL = item.imageURL, let uiImage = loadUIImage(from: imageURL) {
                        NavigationLink(destination: FullImageView(uiImage: uiImage)) {
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
    
    private func loadUIImage(from url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            return uiImage
        }
        return nil
    }
}

// MARK: - Full Image View
struct FullImageView: View {
    let uiImage: UIImage?
    @GestureState private var zoom = 1.0
    var body: some View {
        VStack {
            Spacer()
                if let uiImage = uiImage {
                    let isLandscape = uiImage.size.width > uiImage.size.height
                    
                    if isLandscape {
                        Image(uiImage: flipUIImage(uiImage))
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(zoom)
                            .gesture(
                                MagnificationGesture()
                                    .updating($zoom) { currentState, gestureState, transaction in
                                        gestureState = currentState
                                    }
                            )
                    } else {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(zoom)
                            .gesture(
                                MagnificationGesture()
                                    .updating($zoom) { currentState, gestureState, transaction in
                                        gestureState = currentState
                                    }
                            )
                    }
                }
            Spacer()
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
}

#Preview {
    MediaFeedView()
}
