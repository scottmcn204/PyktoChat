//
//  DrawBubbleView.swift
//  PyktoChat
//
//  Created by Scott McNally on 19/01/2023.
//

import SwiftUI

struct DrawBubbleView: View {
    @State var imageURL: String
    @State var isFromUser: Bool
    
    var body: some View {
        HStack {
            let photoURL = URL(string: imageURL )
            if photoURL != nil{
                AsyncImage(url: photoURL) { phase in
                    switch phase{
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                    case .failure:
                        Text("failed to arrive")
                                .bold()
                    case .empty:
                        ProgressView()
                    @unknown default:
                        fatalError()
                    }
                }
                .frame(width: 370, height: 200).cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 25).stroke(isFromUser ? Color("drawingOuter") : .red, lineWidth: 4 ))
                    .padding(.horizontal)
            }
            
        }
    }
}

struct DrawBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        DrawBubbleView(imageURL: "", isFromUser: true)
    }
}
