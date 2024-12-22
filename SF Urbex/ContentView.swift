//
//  ContentView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VideoFeedViewModel()
    
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.systemGray6
//    }
    
    var body: some View {
        TabView {
            // Home Tab
            VideoFeedView()
                .tabItem {
                    Image(systemName: "house")
//                    Text("Home")
                }

            // Upload Tab
            VideoUploadView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "plus.app")
//                    Text("Upload")
                }

            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
//                    Text("Profile")
                }
        }
        .accentColor(.white)
//        .onAppear {
//            let appearance = UITabBarAppearance()
//            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//            
//            // Use this appearance when scrolling behind the TabView:
//            UITabBar.appearance().standardAppearance = appearance
//            // Use this appearance when scrolled all the way up:
//            UITabBar.appearance().scrollEdgeAppearance = appearance
//        }
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
