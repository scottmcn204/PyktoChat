//
//  CreateProfileView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct CreateProfileView: View {
    @Binding var currentStep: OnboardingStep
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        VStack{
            Text("Setup Profile")
                .font(Font.titleText1)
                .padding(.top, 52)
            Text("Just a few more things to get started")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            Text("Start off with a little picture to denote yourself")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            DrawView().frame(width: 200,height: 200).cornerRadius(200).overlay(RoundedRectangle(cornerRadius: 200).stroke(.blue, lineWidth: 4 ))
                .padding(.top, 15)
            Spacer()
            ZStack{
                Rectangle()
                    .foregroundColor(Color("input"))
                    .cornerRadius(8)
                    .frame(height: 46)
                TextField("First Name", text: $firstName)
            }
            ZStack{
                Rectangle()
                    .foregroundColor(Color("input"))
                    .cornerRadius(8)
                    .frame(height: 46)
                TextField("Last Name", text: $lastName)
            }
            Spacer()
            Button{
                currentStep = .contacts
            } label:{
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding(.horizontal)
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}
