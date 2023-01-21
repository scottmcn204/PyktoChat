//
//  OnboardingContainerView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

enum OnboardingStep: Int{
    case welcome = 0
    case phoneNumber = 1
    case verification = 2
    case profile = 3
    case contacts = 4
}
struct OnboardingContainerView: View {
    @State var currentStep: OnboardingStep = .welcome
    @Binding var isOnboarding: Bool
    var body: some View {
        ZStack{
            Color(.green).opacity(0.2)
                .ignoresSafeArea(edges: [.top, .bottom])
            switch currentStep{
            case .welcome:
                WelcomeView(currentStep: $currentStep)
            case .phoneNumber:
                PhoneNumberView(currentStep: $currentStep)
            case .verification:
                VerificationView(currentStep: $currentStep, isOnboarding: $isOnboarding)
            case .profile:
                CreateProfileView(currentStep: $currentStep)
            case .contacts:
                SyncContactsView(currentStep: $currentStep, isOnboarding: $isOnboarding)
            }
        }
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView(isOnboarding: .constant(true))
    }
}
