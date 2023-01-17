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
    static func getLoggedInUserPhone() -> String{
        return Auth.auth().currentUser?.phoneNumber ?? ""
    }
    static func logOut(){
        try? Auth.auth().signOut()
    }
    static func sendPhoneNumber(phoneNumber: String, completion: @escaping (Error?) -> Void){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            if error == nil{
                UserDefaults.standard.set(verificationId, forKey: "authVerificationId")
            }
            DispatchQueue.main.async{
                completion(error)
            }
        }
    }
    static func verifyCode(typedInCode: String, completion: @escaping (Error?) -> Void){
        let verificationId = UserDefaults.standard.string(forKey: "authVerificationId") ?? ""
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationId,
          verificationCode: typedInCode
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            DispatchQueue.main.async{
                completion(error)
            }
        }
    }
}
