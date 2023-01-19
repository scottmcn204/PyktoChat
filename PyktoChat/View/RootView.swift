//
//  RootView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct RootView: View {
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    @State var isChatShowing = false
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack {
                FriendsListView(isChatShowing: $isChatShowing)
            }
            .fullScreenCover(isPresented: $isOnboarding){
                //onDismiss
                
            } content: {
                // onBoarding sequence
                OnboardingContainerView(isOnboarding: $isOnboarding)
            }
            .fullScreenCover(isPresented: $isChatShowing, onDismiss: nil) {
                ConversationView(isChatShowing : $isChatShowing)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
