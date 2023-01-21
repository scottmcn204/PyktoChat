//
//  ColorPickerView.swift
//  PyktoChat
//
//  Created by Scott McNally on 18/01/2023.
//

import SwiftUI

struct ColorPickerView: View {
    var colors = [Color.black, Color.blue, Color.red, Color.green, Color.orange]
    @Binding var selectedColor: Color
    var body: some View {
        HStack(spacing: 5){
            ForEach(colors, id: \.self){ color in
                Image(systemName: selectedColor == color ? "record.circle.fill" : "circle.fill")
                    .foregroundColor(color)
                    .font(.system(size: 16))
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(Color.black))
    }
}
