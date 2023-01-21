//
//  RootView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var chatViewModel : ChatViewModel
    @EnvironmentObject var contactsViewModel : ContactsViewModel
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    @State var isChatShowing = false
    @State var isSettingsShowing = false
    var body: some View {
        ZStack {
            Color(.green).ignoresSafeArea().opacity(0.2)
            VStack {
                FriendsListView(isChatShowing: $isChatShowing, isSettingsShowing: $isSettingsShowing)
            }
            .onAppear{
                if !isOnboarding{
                    contactsViewModel.getLocalContacts()
                }
            }
            .fullScreenCover(isPresented: $isOnboarding){
                //onDismiss
                
            } content: {
                // onBoarding sequence
                OnboardingContainerView(isOnboarding: $isOnboarding)
            }
            .fullScreenCover(isPresented: $isChatShowing, onDismiss: nil) {
                ConversationView(isChatShowing : $isChatShowing, isEmptyCanvas: true)
            }
            .fullScreenCover(isPresented: $isSettingsShowing, onDismiss: nil, content: {
                SettingsView(isSettingsShowing: $isSettingsShowing, isOnboarding: $isOnboarding)
            })
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active{
                    print("active")
                }
                else if newPhase == .inactive{
                    print("inactive")
                }
                else if newPhase == .background{
                    print("background")
                    chatViewModel.chatListViewClean()
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(ChatViewModel()).environmentObject(ContactsViewModel()).environmentObject(SettingsViewModel())
    }
}
