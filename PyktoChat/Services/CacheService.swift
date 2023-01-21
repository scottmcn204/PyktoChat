//
//  CacheService.swift
//  PyktoChat
//
//  Created by Scott McNally on 19/01/2023.
//

import Foundation
import SwiftUI

class CacheService {
    private static var imageCache = [String : Image]()
    
    static func getImage(key: String) -> Image? {
        return imageCache[key]
    }
    
    static func setImage(image: Image, key: String){
        imageCache[key] = image
    }
}
