//
//  AppView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 12/30/24.
//

import SwiftUI

struct AppView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            MediaFeedView()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            // Upload Tab
            UploadMediaView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "plus.app")
                }
                .tag(1)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(2)
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
            
            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up:
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    AppView()
}
