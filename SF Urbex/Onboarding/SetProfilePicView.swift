////
////  SetProfilePicView.swift
////  Hushpost
////
////  Created by Wheezy Capowdis on 1/1/25.
////
//
//import SwiftUI
//
//struct SetProfilePicView: View {
//    var body: some View {
//        VStack{
//            Text("You can always change your picture later or press Next to skip.")
//                .multilineTextAlignment(.center)
//                .padding()
//            Button {
//
//            } label: {
//                ZStack{
//                    Circle()
//                        .frame(maxWidth: .infinity)
//                        .foregroundColor(.secondary.opacity(0.3))
//                        .padding()
//                        .padding()
//                    VStack {
//                        Image(systemName: "plus")
//                            .font(.largeTitle)
//                            .padding()
//                        Text("Select Photo")
//                            .bold()
//                            .font(.title2)
//                    }
//                }
//            }
//            NavigationLink(destination: FirstPhotoView()) {
//                Text("Next")
//                    .bold()
//                    .font(.title3)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(.white)
//                    .background(Color.blue)
//                    .cornerRadius(15)
//                    .padding()
//            }
//            Spacer()
//        }
//        .navigationTitle("Set Profile Picture")
//        .background(Color.primary.colorInvert().ignoresSafeArea())
//    }
//}
//
//#Preview {
//    NavigationView {
//        SetProfilePicView()
//    }
//}
