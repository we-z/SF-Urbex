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
            SetProfilePicView()
            CreateBioView()
            CreateUsernameView()
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    CreateProfileView()
}
