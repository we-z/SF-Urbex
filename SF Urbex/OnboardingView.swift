//
//  OnboardingView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 12/30/24.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - Internal model for each onboarding page
    struct OnboardingPage {
        let systemName: String
        let title: String
        let description: String
    }
    
    @State private var tabSelection: Int = 0
    
    // MARK: - Updated pages with SF Symbol icons, titles, and descriptions
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            systemName: "eye.slash",
            title: "Defeating mass surveillance",
            description: "Share photos privatly. Protect your memories from prying eyes and mass data collection."
        ),
        OnboardingPage(
            systemName: "lock.icloud.fill",
            title: "Private Sharing Made Easy",
            description: "Securely share your iCloud photos. Enjoy a seamless, privacy-first experience."
        ),
        OnboardingPage(
            systemName: "person.3.fill",
            title: "Private Communities",
            description: "Create exclusive groups for trusted connections. Share and engage within a secure circle."
        ),
        OnboardingPage(
            systemName: "globe",
            title: "Help us make the world more secure",
            description: "Join a movement for privacy-focused photo sharing. Together, we can build a safer digital future."
        )
    ]
    
    var body: some View {
        VStack {
            // MARK: - Scrollable TabView
            TabView(selection: $tabSelection) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack {
                        // Large SF Symbol icon
                        Image(systemName: pages[index].systemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        // Title
                        Text(pages[index].title)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        // Description
                        Text(pages[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            // MARK: - Next / Rate Us Button
            Button(action: {
                if tabSelection < pages.count - 1 {
                    // Move to the next page
                    tabSelection += 1
                } else {
                    // Implement your "Rate us" action here
                    print("Rate us tapped")
                }
            }) {
                Text(tabSelection == pages.count - 1 ? "Rate us" : "Next")
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.primary)
                    .background(Color.secondary.opacity(0.3))
                    .cornerRadius(21)
                    .padding()
            }
        }
        .animation(.easeInOut, value: tabSelection)
    }
}

#Preview {
    OnboardingView()
}
