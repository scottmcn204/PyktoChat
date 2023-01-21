//
//  OnboardingButtonFile.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import Foundation
import SwiftUI

struct OnboardingButtonStyle : ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            Rectangle()
                .frame(height: 50)
                .cornerRadius(4)
                .foregroundColor(Color(.red))
                .scaleEffect(configuration.isPressed ? 1.05 : 1)
                .animation(.easeOut, value: 1)
            configuration.label
                .font(Font.button)
                .foregroundColor(Color("buttonText"))
        }
    }
}
