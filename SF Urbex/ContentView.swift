//
//  ContentView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cloudKitManager = CloudKitManager()

    var body: some View {
        TabView {
            // Home Tab
            VideoFeedView()
                .tabItem {
                    Image(systemName: "house")
                }

            // Upload Tab
            UploadVideoView(cloudKitManager: cloudKitManager)
                .tabItem {
                    Image(systemName: "plus.app")
                }

            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .accentColor(.primary)
    }
}

#Preview {
    ContentView()
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .padding()

            Text("This is where the user profile information will go.")
                .padding()
        }
    }
}
