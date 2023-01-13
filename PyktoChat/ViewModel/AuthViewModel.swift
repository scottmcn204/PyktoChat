//
//  AuthViewModel.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import Foundation
import FirebaseAuth

class AuthViewModel{
    static func isUserLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
    static func getLoggedInUserId() -> String{
        return Auth.auth().currentUser?.uid ?? ""
    }
    static func logOut(){
        try? Auth.auth().signOut()
    }
}
