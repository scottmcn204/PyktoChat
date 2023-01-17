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
                    contactsViewModel.filterContacts(filterBy: textFilter)
                }
            
            if contactsViewModel.filteredUsers.count > 0 {
                List(contactsViewModel.filteredUsers) { user in
                    FriendsRowView(user: user)
                        .listRowBackground(Color.clear)
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

        }.padding(.horizontal)
            .onAppear{
                contactsViewModel.getLocalContacts()
            }
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView().environmentObject(ContactsViewModel())
    }
}
