//
//  ProfilePicView.swift
//  PyktoChat
//
//  Created by Scott McNally on 19/01/2023.
//

import SwiftUI

struct ProfilePicView: View {
    
    @State var participant: User
    
    var body: some View {
        if participant.profilePic == nil{
            ZStack {
                Rectangle().foregroundColor(.white)
                Text(participant.firstName?.prefix(1) ?? "")
                    .bold()
                    .foregroundColor(.black)
            }
            .frame(width: 45, height: 45)
                .cornerRadius(45).overlay(RoundedRectangle(cornerRadius: 45).stroke(.red, lineWidth: 3 ))
                .padding(.trailing, 10)
        }
        else{
            if let cachedImage = CacheService.getImage(key: participant.profilePic!){
                cachedImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                     .cornerRadius(45).overlay(RoundedRectangle(cornerRadius: 45).stroke(.red, lineWidth: 3 ))
            }
            else{
                let photoURL = URL(string: participant.profilePic ?? "")
                AsyncImage(url: photoURL) { phase in
                    switch phase{
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .onAppear{
                                CacheService.setImage(image: image, key: participant.profilePic!)
                            }

                    case .failure:
                        ZStack {
                            Circle().foregroundColor(.white)
                            Text(participant.firstName?.prefix(1) ?? "")
                                .bold()
                        }
                    case .empty:
                        ProgressView()
                    @unknown default:
                        fatalError()
                    }
                }.frame(width: 45, height: 45)
                 .cornerRadius(45).overlay(RoundedRectangle(cornerRadius: 45).stroke(.red, lineWidth: 3 ))
            }

        }
    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(participant: User())
    }
}
