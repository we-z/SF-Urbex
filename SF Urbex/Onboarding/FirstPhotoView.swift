//
//  FirstPhotoView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/2/25.
//

import SwiftUI

struct FirstPhotoView: View {
    var body: some View {
        VStack{
            UploadMediaView(selectedTab: .constant(0))
            Text("Next")
                .bold()
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15)
                .padding()
        }
    }
}

#Preview {
    FirstPhotoView()
}
