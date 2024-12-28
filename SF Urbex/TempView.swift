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
            Color.white
            Color.black
                .aspectRatio(contentMode: .fit)
            HStack(spacing: 42){
                Divider()
                    .frame(width: 6, height: 39)
                    .overlay(.white)
                    .rotationEffect(.degrees(69))
                    .offset(x: 84, y: -30)
                Divider()
                    .frame(width: 6, height: 270)
                    .overlay(.white)
                    .offset(x: 20, y: 110)
                Divider()
                    .frame(width: 12, height: 390)
                    .overlay(.white)
                    .rotationEffect(.degrees(7))
                Divider()
                    .frame(width: 12, height: 390)
                    .overlay(.white)
                    .rotationEffect(.degrees(-7))
                Divider()
                    .frame(width: 6, height: 270)
                    .overlay(.white)
                    .offset(x: -20, y: 110)
                Divider()
                    .frame(width: 6, height: 39)
                    .overlay(.white)
                    .rotationEffect(.degrees(-69))
                    .offset(x: -84, y: -30)
            }
            .offset(y: 25)
            
        }
    }
}

#Preview {
    TempView()
}
