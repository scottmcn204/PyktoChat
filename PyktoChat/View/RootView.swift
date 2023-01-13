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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .padding()
                .font(Font.chatHeading)
            Spacer()
        }
        .fullScreenCover(isPresented: $isOnboarding){
            //onDismiss
        } content: {
            // onBoarding sequence
            OnboardingContainerView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
