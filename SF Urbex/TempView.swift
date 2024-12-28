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
            Color.black
                .aspectRatio(contentMode: .fit)
            Image(systemName: "shield.fill")
                .foregroundColor(.white)
                .font(.system(size: 300))
            Image(systemName: "lock.fill")
                .foregroundColor(.black)
                .font(.system(size: 210))
                .offset(y: -15)
            Image(systemName: "camera.fill")
                .foregroundColor(.white)
                .font(.system(size: 75))
                .offset(y: 27)
            
        }
    }
}

#Preview {
    TempView()
}
