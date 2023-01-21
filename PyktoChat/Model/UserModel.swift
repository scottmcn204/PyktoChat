//
//  UserModel.swift
//  PyktoChat
//
//  Created by Scott McNally on 14/01/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct User : Codable, Identifiable{
    @DocumentID var id : String?
    var firstName : String?
    var lastName : String?
    var phoneNumber : String?
    var profilePic : String?
    var isActive : Bool = true
}
