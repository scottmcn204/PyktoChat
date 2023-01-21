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
    @Binding var isSettingsShowing: Bool
    var body: some View {
        VStack() {
            
            HStack {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text("Friends")
                    .font(Font.pageTitle)
                Spacer()
                Button{
                    isSettingsShowing = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .tint(Color("secondaryIcons"))
                }
            }.padding(.top, 30)
            

            
            ZStack{
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.3)
                    .cornerRadius(20)
                TextField("Search for friends...", text: $textFilter)
                    .padding()
                    .font(Font.tabBar)
                    .foregroundColor(Color("secondaryText"))
            }.frame(height: 46)
                .onChange(of: textFilter) { _ in
                    contactsViewModel.filterContacts(filterBy: textFilter.lowercased()
                        .trimmingCharacters(in: .whitespacesAndNewlines))
                }
                .padding(.bottom, 30)
            
            Divider()
            
            if contactsViewModel.filteredUsers.count > 0 {
                List(contactsViewModel.filteredUsers) { user in
                    if user.isActive{
                        Button{
                            chatViewModel.searchForChatWithFriend(contact: user)
                            isChatShowing = true
                        } label: {
                            FriendsRowView(user: user)

                        }.listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
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
//            List(chatViewModel.chats){ chat in
//                Button{
//                    chatViewModel.selectedChat = chat
//                    isChatShowing = true
//                } label: {
//                    Text(chat.id!)
//                }
//
//            }

        }.padding(.horizontal)
        
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(isChatShowing: .constant(false), isSettingsShowing: .constant(false)).environmentObject(ContactsViewModel()).environmentObject(ChatViewModel())
            .previewDevice("iPhone SE (3rd generation)")
    }
}
