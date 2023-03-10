//
//  PhoneCleaner.swift
//  PyktoChat
//
//  Created by Scott McNally on 14/01/2023.
//

import Foundation

class TextHelper{
    static func sanitizePhone(phone: String) -> String{
        var newPhone: String
        if phone.prefix(4) != "+353"{
            newPhone = ("+353\(phone)")
        }
        else{
            newPhone = phone
        }
        newPhone = newPhone
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if newPhone.prefix(4) == "3530"{
            let intForIndex = 3
            let index = newPhone.index(newPhone.startIndex, offsetBy: intForIndex)
            newPhone.remove(at: index)
        }
        return newPhone
    }
    static func limitText(_ stringVar: inout String, _ limit: Int){
        if stringVar.count > limit{
            stringVar = String(stringVar.prefix(limit))
        }
    }
    static func applyPatternOnNumbers(_ stringVar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringVar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringVar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringVar =  pureNumber
        if stringVar.count > 19{
            stringVar = String(stringVar.prefix(19))
        }
    }
}
