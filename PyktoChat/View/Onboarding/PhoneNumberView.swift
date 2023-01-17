//
//  PhoneNumberView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI
import Combine

struct PhoneNumberView: View {
    @State var phoneNumber = ""
    @Binding var currentStep : OnboardingStep
    var body: some View {
        VStack{
            Text("Verification")
                .font(Font.titleText1)
                .padding(.top, 52)
            Text("Enter your mobile number below. We'll send you a verification code after.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            ZStack{
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("inputField"))
                HStack{
                    TextField("e.g +353 83 111 1111", text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .onReceive(Just(phoneNumber)) { _ in
                            TextHelper.applyPatternOnNumbers(&phoneNumber, pattern: "+### (###) ###-####", replacementCharacter: "#")
                        }
                    Spacer()
                    Button{
                        phoneNumber = ""
                    }label: {
                        Image(systemName: "multiply.circle.fill")

                    }                         .frame(width: 19, height: 19 )
                        .foregroundColor(Color("inputFieldIcons"))
                }.padding(.horizontal)
            }.padding(.top, 34)
            Spacer()
            Button{
                AuthViewModel.sendPhoneNumber(phoneNumber: phoneNumber) { error in
                    if error == nil{
                        currentStep = .verification
                    }
                    else{
                        print(error)
                    }

                }
            } label:{
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding(.horizontal)
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(currentStep: .constant(.phoneNumber))
    }
}
