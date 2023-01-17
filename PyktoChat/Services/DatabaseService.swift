//
//  DatabaseService.swift
//  PyktoChat
//
//  Created by Scott McNally on 14/01/2023.
//

import Foundation
import Contacts
import Firebase
import UIKit
import FirebaseStorage

class DatabaseService{
    func getPlatformUsers(localContacts: [CNContact], completion: @escaping ([User]) -> Void){
        var platformUsers = [User]()
        var phonesToCheck = localContacts.map { contact in
            return TextHelper.sanitizePhone(phone: contact.phoneNumbers.first?.value.stringValue ?? "")
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
    func setUserProfile(firstName: String, lastName: String, profilePic: UIImage?, completion: @escaping (Bool) -> Void){
        guard AuthViewModel.isUserLoggedIn() != false else{
            return
        }
        let db = Firestore.firestore()
        let doc = db.collection("users").document(AuthViewModel.getLoggedInUserId())
        doc.setData(["firstName": firstName,
                     "lastName": lastName,
                     "phoneNumber": TextHelper.sanitizePhone(phone: AuthViewModel.getLoggedInUserPhone())])
        if let image = profilePic{
            let storageReference = Storage.storage().reference()
            let imageData = image.jpegData(compressionQuality: 0.8)
            guard imageData != nil else {
                return
            }
            let path = "profilePics/\(UUID().uuidString).jpg"
            let fileReference = storageReference.child(path)
            let uploadTask = fileReference.putData(imageData!, metadata: nil) { meta, error in
                if error == nil && meta != nil{
                    fileReference.downloadURL { url, error in
                        if url != nil && error == nil{
                            doc.setData(["profilePic" : url!.absoluteString], merge: true) { error in
                                if error == nil{
                                    completion(true)
                                }
                            }
                        }
                        else{
                            completion(false)
                        }
                    }
                }
                else{
                    completion(false)
                }
            }
        }
        else{
            completion(true)
        }
    }
    func checkUserProfile(completion: @escaping (Bool) -> Void){
        guard AuthViewModel.isUserLoggedIn() != false else{
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(AuthViewModel.getLoggedInUserId()).getDocument { snapshot, error in
            if snapshot != nil && error == nil{
                completion(snapshot!.exists)
            }
            else{
                completion(false)
            }

        }
    }
}
