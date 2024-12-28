//
//  ContentView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            // Home Tab
            MediaFeedView()
                .tabItem {
                    Image(systemName: "house")
                }

            // Upload Tab
            UploadMediaView()
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
        NavigationView {
            Text("Profile stuff")
            .navigationTitle("Profile")
        }
    }
}
