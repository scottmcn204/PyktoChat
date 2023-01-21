//
//  FriendsRowView.swift
//  PyktoChat
//
//  Created by Scott McNally on 17/01/2023.
//

import SwiftUI

struct FriendsRowView: View {
    var user: User
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.3)
                .cornerRadius(20)
                .frame(height: 80)
            HStack(spacing: 24){
                let photoURL = URL(string: user.profilePic ?? "")
                if photoURL == nil{
                    ZStack {
                        Rectangle().foregroundColor(.white)
                        Text(user.firstName?.prefix(1) ?? "")
                            .bold()
                            .foregroundColor(.black)
                    }
                    .frame(width: 45, height: 45)
                        .cornerRadius(45).overlay(RoundedRectangle(cornerRadius: 45).stroke(.red, lineWidth: 3 ))
                }
                else{
                    AsyncImage(url: photoURL) { phase in
                        switch phase{
                        case .success(let image):
                            image.resizable()
                                .scaledToFill()
                        case .failure:
                            ZStack {
                                Circle().foregroundColor(.white)
                                Text(user.firstName?.prefix(1) ?? "")
                                    .bold()
                            }
                        case .empty:
                            ProgressView()
                        @unknown default:
                            fatalError()
                        }
                    }   .frame(width: 45, height: 45)
                        .cornerRadius(45).overlay(RoundedRectangle(cornerRadius: 45).stroke(.red, lineWidth: 3 ))
                    
    //                if let image = phase.image{
    //                    image.resizable()
    //                        .scaledToFill()
    //                }
    //                else if phase.error == nil{
    //
    //                }
    //                else{
    //                    ProgressView()
    //                }
                }

                
                VStack(alignment: .leading, spacing: 4) {
                    Text((user.firstName ?? "") + " " + (user.lastName ?? ""))
                        .font(Font.button)
                        .foregroundColor(Color("primaryText"))
                    Text(user.phoneNumber ?? "")
                        .font(Font.bodyParagraph)
                        .foregroundColor(Color("secondaryText"))
                }
                Spacer()
                
                
            }.padding(.horizontal)
        }
    }
}

struct FriendsRowView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsRowView(user: User(firstName: "Test", lastName: "Test", phoneNumber: "test"))
    }
}
