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
        HStack(spacing: 24){
            let photoURL = URL(string: user.profilePic ?? "")
            AsyncImage(url: photoURL) { phase in
//                switch phase{
//                case .success(let image):
//                    image.resizable()
//                        .scaledToFill()
//                case .failure:
//                    ZStack {
//                        Circle().foregroundColor(.white)
//                        Text(user.firstName?.prefix(1) ?? "")
//                            .bold()
//                    }
//                case .empty:
//                    ProgressView()
//                }
                if let image = phase.image{
                    image.resizable()
                        .scaledToFill()
                }
                else if phase.error == nil{
                    ZStack {
                        Rectangle().foregroundColor(.white)
                        Text(user.firstName?.prefix(1) ?? "")
                            .bold()
                            .foregroundColor(.black)
                    }
                }
                else{
                    ProgressView()
                }
            }
            .frame(width: 45, height: 45)
            .cornerRadius(45).overlay(RoundedRectangle(cornerRadius: 45).stroke(.blue, lineWidth: 3 ))
            
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

struct FriendsRowView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsRowView(user: User(firstName: "Test", lastName: "Test", phoneNumber: "test"))
    }
}
