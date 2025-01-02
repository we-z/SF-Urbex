//
//  WarningView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 12/30/24.
//

import SwiftUI

struct WarningView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack {
                // Large SF Symbol icon
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.white)
                        Image(systemName: "hand.raised.app.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    Spacer()
                }
                
                // Title
                Text("We take privacy very seriously!")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Description
                Text("Screen capturing is disabled")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            Spacer()
        }
        .background(Color.primary.colorInvert().ignoresSafeArea())
    }
}

#Preview {
    WarningView()
}
