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
    @EnvironmentObject var contactsViewModel : ContactsViewModel
    @EnvironmentObject var chatViewModel : ChatViewModel
    @State var isButtonDisabled = false
    @State var errorLabelVisible = false
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
                        .foregroundColor(Color("secondaryText"))
                    Spacer()
                    Button{
                        verificationCode = ""
                    }label: {
                        Image(systemName: "multiply.circle.fill")

                    }                         .frame(width: 19, height: 19 )
                        .foregroundColor(Color("inputFieldIcons"))
                }.padding(.horizontal)
            }.padding(.top, 34)
            Text("Invalid Verification Code :(").foregroundColor(.red).font(Font.smallText)
                .padding(.top)
                .opacity(errorLabelVisible ? 1 : 0)
            Spacer()
            Button{
                errorLabelVisible = false
                isButtonDisabled = true
                AuthViewModel.verifyCode(typedInCode: verificationCode) { error in
                    if error == nil{
                        DatabaseService().checkUserProfile { profileExists in
                            if profileExists{
                                contactsViewModel.getLocalContacts()
                                chatViewModel.getChats()
                                isOnboarding = false
                            }
                            else{
                                currentStep = .profile
                            }
                        }
                    }
                    else{
                       errorLabelVisible = true
                    }
                    isButtonDisabled = false
                }
            } label:{
                HStack {
                    Text("Next")
                    if isButtonDisabled {
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

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification), isOnboarding: .constant(true)).environmentObject(ContactsViewModel())
    }
}
