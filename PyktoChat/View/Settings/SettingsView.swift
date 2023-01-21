//
//  SettingsView.swift
//  PyktoChat
//
//  Created by Scott McNally on 19/01/2023.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isSettingsShowing: Bool
    @Binding var isOnboarding: Bool
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    var body: some View {
        ZStack{
            Color(.green).opacity(0.2).ignoresSafeArea()
            VStack{
                HStack {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("Settings")
                        .font(Font.pageTitle)
                    Spacer()
                    Button{
                        isSettingsShowing = false
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .tint(Color(.gray))
                    }
                }.padding(.top, 30)
                Form{
                    Section {
                        Button{
                            AuthViewModel.logOut()
                            isOnboarding = true
                        } label: {
                            Text("Log Out")
                                .font(Font.chatHeading)
                                .padding()
                        }
                    }
                    Section {
                        Button{
                            settingsViewModel.deactivateAccount {
                                AuthViewModel.logOut()
                                isOnboarding = true
                            }
                        } label: {
                            Text("Delete Account")
                                .foregroundColor(.red)
                                .font(Font.chatHeading)
                                .padding()
                        }
                    }
                }.scrollContentBackground(.hidden)
                
                Spacer()
                
                
            }.padding(.horizontal)
            
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isSettingsShowing: .constant(false), isOnboarding: .constant(false)).environmentObject(SettingsViewModel())
    }
}
