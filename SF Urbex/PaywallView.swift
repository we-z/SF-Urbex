//
//  PaywallView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/1/25.
//

import SwiftUI

struct PaywallView: View {
    @State var done: Bool = false
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
                Text("A small price to pay for privacy")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Description
                Text("Join the private photo sharing network. Explore and share photos privately fully E2E encrypted!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            Spacer()
            // MARK: - Next / Rate Us Button
            Button{
                withAnimation(.easeInOut) {
                    done = true
                }
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
        .offset(x: done ? -500 : 0)
    }
}

#Preview {
    PaywallView()
}
