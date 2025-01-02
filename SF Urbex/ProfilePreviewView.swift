//
//  ProfilePreviewView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/2/25.
//

import SwiftUI

struct ProfilePreviewView: View {
    var body: some View {
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
            Spacer()
        }
        .navigationTitle("Profile")
        .padding()
        .padding()
    }
}

#Preview {
    NavigationView {
        ProfilePreviewView()
    }
}
