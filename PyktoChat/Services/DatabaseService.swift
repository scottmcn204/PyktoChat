//
//  DatabaseService.swift
//  PyktoChat
//
//  Created by Scott McNally on 14/01/2023.
//

import Foundation
import Contacts
import Firebase

class DatabaseService{
    func getPlatformUsers(localContacts: [CNContact], completion: @escaping ([User]) -> Void){
        var platformUsers = [User]()
        var phonesToCheck = localContacts.map { contact in
            return PhoneCleaner.sanitizePhone(phone: contact.phoneNumbers.first?.value.stringValue ?? "")
        }
        guard phonesToCheck.count > 0 else{
            completion(platformUsers)
            return
        }
        let db = Firestore.firestore()

        while !phonesToCheck.isEmpty{
            let firstTenPhones = Array(phonesToCheck.prefix(10))
            phonesToCheck = Array(phonesToCheck.dropFirst(10))
            let query = db.collection("users").whereField("phoneNumber", in: firstTenPhones) // only does 10 at a time
            query.getDocuments { snapshot, error in
                if error == nil && snapshot != nil{
                    for document in snapshot!.documents{
                        if let user = try? document.data(as: User.self){
                            platformUsers.append(user)
                        }
                    }
                    if phonesToCheck.isEmpty{
                        completion(platformUsers)
                    }
                }
            }
        }
    }
}
