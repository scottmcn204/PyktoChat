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
    @State var isButtonDisabled = false
    @State var errorLabelVisible = false
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
                        .foregroundColor(Color("secondaryText"))
//                        .placeholder(when: phoneNumber.isEmpty) {
//                            Text("e.g +353 83 111 1111")
//                                .foregroundColor(Color("secondaryText"))
//                        }
                    Spacer()
                    Button{
                        phoneNumber = ""
                    }label: {
                        Image(systemName: "multiply.circle.fill")

                    }                         .frame(width: 19, height: 19 )
                        .foregroundColor(Color("inputFieldIcons"))
                }.padding(.horizontal)
                
            }.padding(.top, 34)
            Text("Please Enter a valid Phone Number").foregroundColor(.red).font(Font.smallText)
                .padding(.top)
                .opacity(errorLabelVisible ? 1 : 0)
            Spacer()
            Button{
                errorLabelVisible = false
                isButtonDisabled = true
                AuthViewModel.sendPhoneNumber(phoneNumber: phoneNumber) { error in
                    if error == nil{
                        currentStep = .verification
                    }
                    else{
                        errorLabelVisible = true
                    }
                    isButtonDisabled = false

                }
            } label:{
                
                HStack {
                    Text("Next")
                    if isButtonDisabled{
                        ProgressView()
                            .padding(.leading)
                    }
                }
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
            .disabled(isButtonDisabled)
        }
        .padding(.horizontal)
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(currentStep: .constant(.phoneNumber))
    }
}
