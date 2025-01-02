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
            VStack{
                Circle()
                    .frame(width: 150, height: 150)
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
            Spacer()
            Text("Continue")
                .bold()
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15)
                .padding()
        }
        .navigationTitle("Profile")
        
    }
}

#Preview {
    NavigationView {
        ProfilePreviewView()
    }
}
