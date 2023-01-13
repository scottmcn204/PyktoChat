//
//  DrawView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var color: Color = .blue
    var lineWidth: Double = 2.0
}

struct DrawView: View {
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    var body: some View {
        VStack{
            Canvas{ context, size in
                    
                for line in lines{
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                }
                    
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
                    let newPoint = value.location
                    currentLine.points.append(newPoint)
                    self.lines.append(currentLine)
                })
                .onEnded({ value in
                    //self.lines.append(currentLine)
                    self.currentLine = Line(points: [])
                })
            )
        }
    }
}

struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView()
    }
}
