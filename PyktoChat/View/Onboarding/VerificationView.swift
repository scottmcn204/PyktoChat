//
//  VerificationView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI
import Combine

struct VerificationView: View {
    @Binding var currentStep : OnboardingStep
    @Binding var isOnboarding : Bool
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
                        .keyboardType(.numberPad)
                        .onReceive(Just(verificationCode)) { _ in
                            TextHelper.limitText(&verificationCode, 6)
                        }
                    
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
                AuthViewModel.verifyCode(typedInCode: verificationCode) { error in
                    if error == nil{
                        DatabaseService().checkUserProfile { profileExists in
                            if profileExists{
                                isOnboarding = false
                            }
                            else{
                                currentStep = .profile
                            }
                        }
                    }
                    else{
                        //handle error
                    }
                    currentStep = .profile
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

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification), isOnboarding: .constant(true))
    }
}
