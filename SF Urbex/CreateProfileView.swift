//
//  CreateProfileView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/1/25.
//

import SwiftUI

struct CreateProfileView: View {
    var body: some View {
        ZStack {
            CreateBioView()
            CreateUsernameView()
        }
    }
}

#Preview {
    CreateProfileView()
}
