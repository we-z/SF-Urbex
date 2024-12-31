//
//  WelcomeView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 12/30/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack {
                // Large SF Symbol icon
                ZStack{
                    Image(systemName: "lock.shield.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.white)
                        .padding()
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .offset(y: 12)
                        .foregroundColor(.white)
                        .padding()
                }
                
                // Title
                Text("Welcome to Hushpost!")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Description
                Text("Join the social-privacy network and start sharing photos privately fully E2E encrypted!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            Spacer()
            // MARK: - Next / Rate Us Button
            Button{
                
            } label: {
                Text("Continue")
                    .bold()
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .cornerRadius(21)
                    .padding()
            }
        }
        .background(Color.blue.ignoresSafeArea())
    }
}

#Preview {
    WelcomeView()
}
