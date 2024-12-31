//
//  ContentView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/21/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        ZStack {
            AppView()
            OnboardingView()
            WelcomeView()
        }
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
