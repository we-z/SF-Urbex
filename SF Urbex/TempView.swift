//
//  TempView.swift
//  SF Urbex
//
//  Created by Wheezy Capowdis on 12/22/24.
//

import SwiftUI
import AVKit

struct TempView: View {
    var body: some View {
        ZStack {
            Color.blue
                .aspectRatio(contentMode: .fit)
            Image(systemName: "shield.fill")
                .foregroundColor(.white)
                .font(.system(size: 360))
                .shadow(color: .black, radius: 2)
            Image(systemName: "lock.fill")
                .foregroundColor(.blue)
                .font(.system(size: 250))
                .offset(y: -15)
                .shadow(color: .black, radius: 0.1)
            Image(systemName: "photo.fill")
                .foregroundColor(.white)
                .font(.system(size: 110))
                .offset(y: 35)
            
        }
    }
}

#Preview {
    TempView()
}
