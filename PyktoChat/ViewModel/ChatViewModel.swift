//
//  ChatViewModel.swift
//  PyktoChat
//
//  Created by Scott McNally on 18/01/2023.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var chats = [Chat]()
    @Published var selectedChat : Chat?
    @Published var messages = [ChatMessage]()
    var databaseService = DatabaseService()
    
    init(){
        getChats()
    }
    
    func getChats(){
        databaseService.getAllChats { chats in
            self.chats = chats
        }
    }
    func getMessages(){
        guard selectedChat != nil else{
            return
        }
        databaseService.getAllMessages(chat: selectedChat!) { messages in
            self.messages = messages
        }
    }
    func sendDrawing(drawing: UIImage){
        guard selectedChat != nil else{
            return
        }
        databaseService.sendDrawing(drawing: drawing, chat: selectedChat!)
    }
    func getParticipantIds() -> [String]{
        guard selectedChat != nil else{
            return [String]()
        }
        let ids = selectedChat!.participants.filter{ id in
            id != AuthViewModel.getLoggedInUserId()
        }
        return ids
    }
    func searchForChatWithFriend(contact: User){
        guard contact.id != nil else{
            return
        }
        let foundChat = chats.filter{ chat in
            return chat.numParticipants == 2 && chat.participants.contains(contact.id!)
        }
        if !foundChat.isEmpty {
            self.selectedChat = foundChat.first
            getMessages()
        }
        else {
            let newChat = Chat(id: nil, numParticipants: 2, participants: [AuthViewModel.getLoggedInUserId(), contact.id!])
            self.selectedChat = newChat
            databaseService.createChat(chat: newChat) { documentId in
                self.selectedChat = Chat(id: documentId, numParticipants: 2, participants: [AuthViewModel.getLoggedInUserId(), contact.id!])
                self.chats.append(self.selectedChat!)

            }

        }
    }
    
    func conversationViewClean() {
        databaseService.detatchConversationViewListners()
    }
    
    func chatListViewClean() {
        databaseService.detatchChatListViewListners()
    }
}
