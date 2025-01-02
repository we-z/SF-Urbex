//
//  PaywallView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/1/25.
//

import SwiftUI

struct PaywallView: View {
    @State var done: Bool = false

    // Features of the private photo-sharing app and their respective icons
    let featuresWithIcons = [
        ("End-to-End Encryption", "lock.fill"),
        ("No Ads, No Tracking", "eye.slash.fill"),
        ("Private Group Sharing", "person.2.fill"),
        ("Anonymous Messaging", "message"),
        ("Self-Destructing Photos", "flame.fill"),
        ("Granular Privacy Controls", "slider.horizontal.3"),
        ("Password-Protection", "key.fill"),
        ("FaceID-Protection", "faceid"),
        ("Open Source Code", "chevron.left.slash.chevron.right"),
        ("Verified Secure Builds", "checkmark.shield.fill"),
        ("No Screenshots", "camera.aperture"),
        ("No Screenrecordings", "video.slash.fill"),
        ("Exclusive Membership", "crown.fill"),
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
                            .offset(x: 0, y: 12)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .fixedSize()
                    
                    // Title
                    Text("Privacy is priceless")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Description
                    Text("Secure your most valuable memories. Explore and share photos privately.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Features
                    VStack {
                        ForEach(featuresWithIcons, id: \.0) { feature, icon in
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
                                Image(systemName: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                    .padding(.trailing, 6)
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
                    .shadow(color: .black, radius: 0.3)
                Text("1 month free trial, then $19.99 / month")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top, 6)
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
        .offset(y: done ? 1000 : 0)
    }
}

#Preview {
    PaywallView()
}
