//
//  VerificationView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct VerificationView: View {
    @Binding var currentStep : OnboardingStep
    @State var verificationCode = ""
    var body: some View {
        VStack{
            Text("Verification")
                .font(Font.titleText1)
                .padding(.top, 52)
            Text("Enter the 6-digit verification code we sent to your device")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            ZStack{
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("inputField"))
                HStack{
                    TextField("", text: $verificationCode)
                    Spacer()
                    Button{
                        verificationCode = ""
                    }label: {
                        Image(systemName: "multiply.circle.fill")

                    }                         .frame(width: 19, height: 19 )
                        .foregroundColor(Color("inputFieldIcons"))
                }.padding(.horizontal)
            }.padding(.top, 34)
            Spacer()
            Button{
                currentStep = .profile
            } label:{
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding(.horizontal)
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification))
    }
}
