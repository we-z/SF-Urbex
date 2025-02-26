//
//  OnboardingView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 12/30/24.
//

import SwiftUI
import StoreKit

struct OnboardingView: View {
    
    // MARK: - Internal model for each onboarding page
    struct OnboardingPage {
        let systemName: String
        let title: String
        let description: String
    }
    
    @State private var tabSelection: Int = 0
    @State var done: Bool = false
    
    // MARK: - Updated pages with SF Symbol icons, titles, and descriptions
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            systemName: "eye.slash",
            title: "Escape Social Media Surveillance",
            description: "Share photos privatly. Protect your memories from prying eyes and mass data collection."
        ),
        OnboardingPage(
            systemName: "lock.icloud.fill",
            title: "Private Photo Sharing Made Easy",
            description: "Securely share your iCloud photos in full resolution with a privacy-first experience."
        ),
        OnboardingPage(
            systemName: "person.3.fill",
            title: "Private Community Building",
            description: "Create exclusive groups for trusted connections. Share and engage within a secure circle."
        ),
        OnboardingPage(
            systemName: "globe",
            title: "Help us make the world more secure!",
            description: "Join the movement for social privacy. Together, we can build a safer digital future."
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
                            .foregroundColor(.blue)
                            .padding()
                        
                        if index == pages.count - 1 {
                            HStack{
                                ForEach(0..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45) // Adjust the size as needed
                                        .foregroundColor(.yellow)
                                        
                                }
                            }
                            .padding()
                            
                        }
                        
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
                            .padding()
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
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        DispatchQueue.main.async {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }
                    withAnimation(.easeInOut) {
                        done = true
                    }
                }
            }) {
                Text(tabSelection == pages.count - 1 ? "Rate Us" : "Next")
                    .bold()
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(21)
                    .padding()
            }
        }
        .background(Color.primary.ignoresSafeArea().colorInvert())
        .animation(.spring, value: tabSelection)
        .offset(x: done ? -500 : 0)
    }
}

#Preview {
    OnboardingView()
}
