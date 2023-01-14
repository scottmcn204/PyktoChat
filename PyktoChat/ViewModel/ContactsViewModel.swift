//
//  ContactsViewModel.swift
//  PyktoChat
//
//  Created by Scott McNally on 14/01/2023.
//

import Foundation
import Contacts

class ContactsViewModel: ObservableObject{
    
    @Published var users = [User]()
    
    private var localContacts = [CNContact]()
    
    func getLocalContacts(){
        DispatchQueue.init(label: "getContacts").async { //perform code asynchrously to UI
            do{
                let store = CNContactStore()
                let keys = [CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, success in
                    self.localContacts.append(contact)
                })
                DatabaseService().getPlatformUsers(localContacts: self.localContacts) { platformUsers in
                    DispatchQueue.main.async { // update the ui in the main thread
                        self.users = platformUsers
                    }
                }
            } catch {
                
            }
        }
    }
}
