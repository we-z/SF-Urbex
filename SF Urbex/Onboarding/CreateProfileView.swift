//
//  CreateProfileView.swift
//  Hushpost
//
//  Created by Wheezy Capowdis on 1/1/25.
//
import SwiftUI

struct CreateProfileView: View {
    @State private var username: String = ""
    @State private var bio: String = ""
    @State private var imageURL: URL? = nil
    @State private var done: Bool = false

    var body: some View {
        ZStack {
            NavigationView {
                CreateUsernameView(username: $username, done: $done, bio: $bio, imageURL: $imageURL)
            }
            .offset(x: done ? -500 : 0)
            .animation(.easeInOut(duration: 0.3), value: done)
        }
    }
}

struct CreateUsernameView: View {
    @Binding var username: String
    @Binding var done: Bool
    @Binding var bio: String
    @Binding var imageURL: URL?

    var body: some View {
        VStack {
            Text("Pick a username for your new account. You can always change it later.")
                .multilineTextAlignment(.center)
                .padding()
            TextField("Username", text: $username)
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
            NavigationLink(destination: CreateBioView(bio: $bio, username: $username, imageURL: $imageURL, done: $done)) {
                Text("Next")
                    .bold()
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .opacity(username.isEmpty ? 0.5 : 1)
                    .padding()
            }
            .disabled(username.isEmpty)
            Spacer()
        }
        .navigationTitle("Create Username")
    }
}

struct CreateBioView: View {
    @Binding var bio: String
    @Binding var username: String
    @Binding var imageURL: URL?
    @Binding var done: Bool

    var body: some View {
        VStack {
            Text("Write as much as you would like. You can always change it later or press Next to skip.")
                .multilineTextAlignment(.center)
                .padding()
            TextField("Bio", text: $bio, axis: .vertical)
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
            NavigationLink(destination: SetProfilePicView(imageURL: $imageURL, done: $done)) {
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
            Spacer()
        }
        .navigationTitle("Write a Bio")
    }
}

struct SetProfilePicView: View {
    @Binding var imageURL: URL?
    @Binding var done: Bool

    var body: some View {
        VStack {
            Text("You can always change your picture later or press Next to skip.")
                .multilineTextAlignment(.center)
                .padding()
            Button {
                // Add logic to select a photo here
            } label: {
                ZStack {
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
            NavigationLink(destination: ProfilePreviewView(done: $done)) {
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
            Spacer()
        }
        .navigationTitle("Set Profile Picture")
    }
}

struct ProfilePreviewView: View {
    @Binding var done: Bool

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Circle()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.secondary.opacity(0.3))
                        .padding()
                    Text("Anon.Urbexer")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Text("Exploring the urban world. Capturing the moments that matter most.")
                        .multilineTextAlignment(.center)
                }
                .padding()
                .padding()
                // Add posts or other content here
            }
            Button {
                done = true
            } label: {
                Text("Continue")
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
        .navigationTitle("Profile Preview")
    }
}

#Preview {
    CreateProfileView()
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
