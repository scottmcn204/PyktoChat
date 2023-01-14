//
//  PhoneCleaner.swift
//  PyktoChat
//
//  Created by Scott McNally on 14/01/2023.
//

import Foundation

class PhoneCleaner{
    static func sanitizePhone(phone: String) -> String{
        return phone
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
