//
//  ViewExtensions.swift
//  PyktoChat
//
//  Created by Scott McNally on 20/01/2023.
//

import Foundation
import SwiftUI

extension View{
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: .leading) {
                placeholder().opacity(shouldShow ? 1 : 0)
            }
            
    }
}



