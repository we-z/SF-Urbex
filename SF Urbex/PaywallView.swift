//
//  PaywallView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/1/25.
//

import SwiftUI

struct PaywallView: View {
    @State var done: Bool = false

    // Features of the private photo-sharing app
    let features = [
        "End-to-End Encryption",
        "Private Photo Sharing",
        "Exclusive Membership",
        "Ad-Free Experience",
        "Secure Data Storage"
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    // Large SF Symbol icon
                    ZStack {
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
                    Text("A small price to pay for your privacy")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Description
                    Text("Join the private photo sharing network. Explore and share photos privately fully E2E encrypted!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Features
                    VStack {
                        ForEach(features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.green)
                                Text(feature)
                                    .bold()
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)
                    .padding()
                }
            }
            .scrollIndicators(.hidden)
            VStack {
                Divider()
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                Text("1 month free trial, then $14.99 / month")
                    .bold()
                    .font(.title3)
                    .padding()
                    .foregroundColor(.black)
                Button {
                    withAnimation(.easeInOut) {
                        done = true
                    }
                } label: {
                    Text("Continue")
                        .bold()
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(60)
                        .padding([.horizontal])
                }
                Text("Restore Purchase | Terms | Privacy")
                    .font(.headline)
                    .padding(6)
                    .foregroundColor(.gray)
            }
            .background(.white)
            
        }
        .background(Color.blue.ignoresSafeArea())
        .offset(x: done ? -500 : 0)
    }
}

#Preview {
    PaywallView()
}
