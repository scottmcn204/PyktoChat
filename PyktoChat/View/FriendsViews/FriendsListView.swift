//
//  FriendsListView.swift
//  PyktoChat
//
//  Created by Scott McNally on 17/01/2023.
//

import SwiftUI

struct FriendsListView: View {
    @State var textFilter = ""
    @EnvironmentObject var contactsViewModel : ContactsViewModel
    @EnvironmentObject var chatViewModel : ChatViewModel
    @Binding var isChatShowing: Bool
    var body: some View {
        VStack() {
            
            HStack {
                Text("Your Friends")
                    .font(Font.pageTitle)
                Spacer()
                Button{
                    AuthViewModel.logOut()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .frame(width: 20, height: 20)
                        .tint(Color("secondaryIcons"))
                }
            }.padding(.top, 20)
            
            ZStack{
                Rectangle()
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                TextField("Search for friends...", text: $textFilter)
                    .padding()
                    .font(Font.tabBar)
                    .foregroundColor(Color("secondaryIcons"))
            }.frame(height: 46)
                .onChange(of: textFilter) { _ in
                    contactsViewModel.filterContacts(filterBy: textFilter.lowercased()
                        .trimmingCharacters(in: .whitespacesAndNewlines))
                }
            
            if contactsViewModel.filteredUsers.count > 0 {
                List(contactsViewModel.filteredUsers) { user in
                    Button{
                        isChatShowing = true
                    } label: {
                        FriendsRowView(user: user)

                    }.listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .padding(.top, 12)
            }
            else{
                Spacer()
                Image("no-contacts-yet")
                Text("We can't find any friends...")
                    .font(Font.titleText1)
                    .padding(.top, 32)
                Text("Maybe invite some or get some cooler friends who use our app")
                    .font(Font.bodyParagraph)
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                Spacer()
            }
            List(chatViewModel.chats){ chat in
                Button{
                    chatViewModel.selectedChat = chat
                    isChatShowing = true
                } label: {
                    Text(chat.id!)
                }

            }

        }.padding(.horizontal)
            .onAppear{
                contactsViewModel.getLocalContacts()
            }
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(isChatShowing: .constant(false)).environmentObject(ContactsViewModel()).environmentObject(ChatViewModel())
    }
}
