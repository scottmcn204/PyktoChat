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
                .foregroundColor(Color("button"))
            configuration.label
                .font(Font.button)
                .foregroundColor(Color("buttonText"))
        }
    }
}
