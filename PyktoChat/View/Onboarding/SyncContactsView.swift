//
//  SyncContactsView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct SyncContactsView: View {
    @Binding var currentStep: OnboardingStep
    @Binding var isOnboarding: Bool
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    var body: some View {
        VStack{
            Spacer()
            Image("onboarding-all-set")
            Text("Set-up Complete!")
                .font(Font.titleText1)
                .padding(.top, 32)
            Text("Continue to start chatting with your friends")
                .font(Font.bodyParagraph)
                .padding(.top, 8)
            Spacer()
            Button{
                isOnboarding = false
            } label: {
                Text("Continue")
            }.buttonStyle(OnboardingButtonStyle())
                .padding(.bottom, 87)
        }.padding(.horizontal)
            .onAppear{
                contactsViewModel.getLocalContacts()
            }
    }
}

struct SyncContactsView_Previews: PreviewProvider {
    static var previews: some View {
        SyncContactsView(currentStep: .constant(.contacts), isOnboarding: .constant(true)).environmentObject(ContactsViewModel())
    }
}
