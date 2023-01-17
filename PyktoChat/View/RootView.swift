//
//  RootView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct RootView: View {
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack {
                FriendsListView()
            }
            .fullScreenCover(isPresented: $isOnboarding){
                //onDismiss
                
            } content: {
                // onBoarding sequence
                OnboardingContainerView(isOnboarding: $isOnboarding)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
