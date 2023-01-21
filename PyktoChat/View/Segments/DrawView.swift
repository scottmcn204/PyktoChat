//
//  DrawView.swift
//  PyktoChat
//
//  Created by Scott McNally on 13/01/2023.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var color: Color = .black
    var lineWidth: Double = 2.0
//    static func saveDrawing(bgColor: UIColor, lineColor: UIColor, size: CGSize, points: [CGPoint]) -> UIImage {
//        let format = UIGraphicsImageRendererFormat()
//        format.scale = 1
//        format.opaque = true
//        let renderer = UIGraphicsImageRenderer(size: size, format: format)
//        let image = renderer.image { context in
//            context.cgContext.setFillColor(bgColor.cgColor)
//            context.cgContext.addRect(CGRect(origin: .zero, size: size))
//            context.cgContext.drawPath(using: .fill)
//            let bez = UIBezierPath()
//            bez.move(to: points[0])
//            for i in 1...points.count{
//                bez.addLine(to: points[i])
//            }
//            context.cgContext.setFillColor(UIColor.clear.cgColor)
//            context.cgContext.setStrokeColor(lineColor.cgColor)
//            context.cgContext.setLineWidth(2)
//            context.cgContext.setLineJoin(.round)
//            context.cgContext.setLineCap(.round)
//            context.cgContext.addPath(bez.cgPath)
//            context.cgContext.drawPath(using: .stroke)
//        }
//        return image
//    }
}

struct DrawView: View {
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    var body: some View {
        ZStack {
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
                        self.currentLine = Line(points: [])
                    })
                )
            }
        }
    }
}

struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView()
    }
}
