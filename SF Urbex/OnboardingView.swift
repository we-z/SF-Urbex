//
//  OnboardingView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 12/30/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var tabSelection: Int = 0
        
        // Example pages for the onboarding flow
        private let pages = [
            "Defeating mass surveillance",
            "A new world of social privacy",
            "Help us make the world more secure"
        ]
        
        var body: some View {
            VStack {
                // MARK: - Scrollable TabView
                TabView(selection: $tabSelection) {
                    ForEach(pages.indices, id: \.self) { index in
                        VStack {
                            Text(pages[index])
                                .font(.largeTitle)
                                .bold()
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
