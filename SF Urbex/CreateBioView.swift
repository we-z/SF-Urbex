//
//  CreateBioView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/1/25.
//

import SwiftUI

struct CreateBioView: View {
    @State var username: String = ""
    var body: some View {
        VStack{
            Text("Create a Bio")
                .bold()
                .font(.largeTitle)
                .padding()
            Text("Tell us about yourself. write as much as you would like. You can always change it later.")
                .multilineTextAlignment(.center)
                .padding()
            TextField("Bio", text: $username, axis: .vertical)
                .textFieldStyle(.plain)
                .padding()
                .font(.title3)
                .frame(maxWidth: .infinity)
                .background(.secondary.opacity(0.3))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                .accentColor(.primary)
                .textFieldStyle(.roundedBorder)
                .padding()
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
    }
}

#Preview {
    CreateBioView()
}
