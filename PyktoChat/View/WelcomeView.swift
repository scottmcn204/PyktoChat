//
//  WelcomeView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currentStep: OnboardingStep
    var body: some View {
        VStack{
            Spacer()
            Image("onboarding-welcome")
            Text("Welcome to the PyktoChat App")
                .font(Font.titleText1)
                .padding(.top, 32)
            Text("Nostalgic and FUN chat app")
                .font(Font.bodyParagraph)
                .padding(.top, 8)
            Spacer()
            Button{
                currentStep = .phoneNumber
            } label: {
                Text("Get Started")
            }.buttonStyle(OnboardingButtonStyle())
            
            Text("By tapping 'Get Started', you agree to our Privacy Policy ")
                .font(Font.smallText)
                .padding(.top, 14)
                .padding(.bottom, 61)
        }.padding(.horizontal)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(currentStep: .constant(.welcome))
    }
}
