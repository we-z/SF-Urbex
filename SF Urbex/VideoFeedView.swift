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
    @State private var feed = 0

    var body: some View {
        NavigationView {
            VStack{
                ScrollView {
                    LazyVStack {
                        ForEach(cloudKitManager.mediaItems) { item in
                            MediaCard(item: item)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Hushpost")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("Pressed")
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title3)
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            print("Pressed")
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.title3)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Picker("", selection: $feed) {
                            Text("Everyone").tag(0)
                            Text("Following").tag(1)
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

// MARK: - Full Image View
struct FullImageView: View {
    let uiImage: UIImage?
    @State var scale = 1.0
    @State var lastScale = 0.0
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    var body: some View {
        VStack {
            Spacer()
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged({ value in
                                    withAnimation(.interactiveSpring()) {
                                        scale = handleScaleChange(value)
                                    }
                                })
                                .onEnded({ _ in
                                    lastScale = scale
                                })
                                .simultaneously(
                                    with: DragGesture(minimumDistance: 0)
                                        .onChanged({ value in
                                            withAnimation(.interactiveSpring()) {
                                                offset = handleOffsetChange(value.translation)
                                            }
                                        })
                                        .onEnded({ _ in
                                            lastOffset = offset
                                        })

                                )
                        )
                }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("Pressed")
                } label: {
                    Image(systemName: "heart")
                        .font(.title3)
                }
            }
        }
        
    }
    
    private func handleScaleChange(_ zoom: CGFloat) -> CGFloat {
        lastScale + zoom - (lastScale == 0 ? 0 : 1)
    }
    
    private func handleOffsetChange(_ offset: CGSize) -> CGSize {
        var newOffset: CGSize = .zero

        newOffset.width = offset.width + lastOffset.width
        newOffset.height = offset.height + lastOffset.height

        return newOffset
    }
}

#Preview {
    MediaFeedView()
}
