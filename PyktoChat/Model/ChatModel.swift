//
//  ChatModel.swift
//  PyktoChat
//
//  Created by Scott McNally on 18/01/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat : Codable, Identifiable{
    @DocumentID var id: String?
    var numParticipants : Int
    var participants : [String]
    var messages : [ChatMessage]?
}

struct ChatMessage : Codable, Identifiable, Hashable{
    @DocumentID var id : String?
    var imageURL : String
    var senderId : String
    @ServerTimestamp var timeStamp : Date?
}
