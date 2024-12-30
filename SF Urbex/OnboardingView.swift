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
            description: "We use cutting-edge encryption and privacy-first technologies to keep your messages and data safe from prying eyes. Feel confident knowing your personal information stays truly personal."
        ),
        OnboardingPage(
            systemName: "lock.shield",
            title: "A new world of social privacy",
            description: "Connect with friends and loved ones without worrying about data leaks. Our secure sharing features help you communicate freely without sacrificing convenience."
        ),
        OnboardingPage(
            systemName: "person.3.fill",
            title: "Private Communities",
            description: "Build and join invite-only groups that are fully protected. Share ideas, collaborate on projects, or just hang out with people you trust, all behind a secure digital wall."
        ),
        OnboardingPage(
            systemName: "globe.europe.africa.fill",
            title: "Help us make the world more secure",
            description: "As more people join, our network grows stronger, pushing towards a future where online privacy is the norm. Let’s reshape the digital landscape together."
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
                            .padding(.bottom, 20)
                        
                        // Title
                        Text(pages[index].title)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                        
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
                    .foregroundColor(.white)
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
