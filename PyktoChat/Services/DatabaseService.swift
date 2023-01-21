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
    
    var chatListViewListeners = [ListenerRegistration]()
    var conversationViewListeners = [ListenerRegistration]()
    
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
                     "isActive": true,
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
    
    
    func getAllChats(completion: @escaping ([Chat]) -> Void){
        let db = Firestore.firestore()
        let chatsQuery = db.collection("chats").whereField("participants", arrayContains: AuthViewModel.getLoggedInUserId())
        let listener = chatsQuery.addSnapshotListener { snapshot, error in
            if snapshot != nil && error == nil{
                var chats = [Chat]()
                for doc in snapshot!.documents{
                    let chat = try? doc.data(as: Chat.self)
                    if let chat = chat{
                        chats.append(chat)
                    }
                }
                completion(chats)
            }
            else{
                print("error in database retrieval")
            }
        }
        chatListViewListeners.append(listener)
    }
    func getAllMessages(chat : Chat, completion: @escaping ([ChatMessage]) -> Void){
        guard chat.id != nil else{
            completion([ChatMessage]())
            return
        }
        let db = Firestore.firestore()
        let messagesQuery = db.collection("chats").document(chat.id!).collection("messages").order(by: "timeStamp")
        let listner = messagesQuery.addSnapshotListener{ snapshot, error in
            if snapshot != nil && error == nil{
                var messages = [ChatMessage]()
                for doc in snapshot!.documents{
                    let message = try? doc.data(as: ChatMessage.self)
                    if let message = message {
                        messages.append(message)
                    }
                }
                completion(messages)
            }
            else{
                print("error in database retrieval")
            }
        }
        conversationViewListeners.append(listner)
    }
    func sendDrawing(drawing: UIImage, chat: Chat){
        guard chat.id != nil else{
            return
        }
        let db = Firestore.firestore()
        let doc = db.collection("chats").document(chat.id!).collection("messages").addDocument(data: [
            "senderId" : AuthViewModel.getLoggedInUserId(),
            "timeStamp" : Date()
        ])
        let image = drawing
        let storageReference = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        let path = "drawings/\(UUID().uuidString).jpg"
        let fileReference = storageReference.child(path)
        let uploadTask = fileReference.putData(imageData!, metadata: nil) { meta, error in
            if error == nil && meta != nil{
                fileReference.downloadURL { url, error in
                    if url != nil && error == nil{
                        doc.setData(["imageURL" : url!.absoluteString], merge: true) { error in
                            if error == nil{
                                return
                            }
                        }
                    }
                    else{
                        return
                    }
                }
            }
            else{
                return
            }
        }
    }
    func createChat(chat: Chat, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let doc =  db.collection("chats").document()
        try? doc.setData(from: chat, completion: { error in
            completion(doc.documentID)
        })
    }
    
    func detatchChatListViewListners() {
        for listener in chatListViewListeners {
            listener.remove()
        }
    }
    func detatchConversationViewListners() {
        for listener in conversationViewListeners {
            listener.remove()
        }
    }
    
    func deactivateAccount(completion: @escaping () -> Void){
        guard AuthViewModel.isUserLoggedIn() else{
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(AuthViewModel.getLoggedInUserId()).setData(
            ["isActive" : false,
             "firstName" : "Deleted",
             "lastName": "user"],
            merge: true) { error in
            if error == nil {
                completion()
            }
        }
    }
}
