//
//  SetProfilePicView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/1/25.
//

import SwiftUI

struct SetProfilePicView: View {
    @State var done: Bool = false
    var body: some View {
        VStack{
            Text("Set Profile Picture")
                .bold()
                .font(.largeTitle)
                .padding()
            Text("You can always change your picture later or press Next to skip.")
                .multilineTextAlignment(.center)
                .padding()
            Button {
                withAnimation(.easeInOut) {
                    done = true
                }
            } label: {
                ZStack{
                    Circle()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary.opacity(0.3))
                        .padding()
                        .padding()
                    VStack {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .padding()
                        Text("Select Photo")
                            .bold()
                            .font(.title2)
                    }
                }
            }
            Text("Next")
                .bold()
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15)
                .padding()
            Spacer()
        }
        .background(Color.primary.colorInvert().ignoresSafeArea())
        .offset(x: done ? -500 : 0)
    }
}

#Preview {
    SetProfilePicView()
}
