//
//  ViewPort.swift
//  QuickCam
//
//  Created by Kim Nguyen on 14.02.24.
//

import SwiftUI

public struct ViewPort: Shape {
    let cornerRadius: CGFloat
    let visibleCornerLenght: CGFloat

    public init(cornerRadius: CGFloat, visibleCornerLenght: CGFloat) {
        self.cornerRadius = cornerRadius
        self.visibleCornerLenght = visibleCornerLenght
    }

    public func path(in rect: CGRect) -> Path {
        let lenght = max(cornerRadius, visibleCornerLenght)

        return Path { path in
            // TopLeft corner
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + lenght))
            path.addLine(to: CGPoint(x: rect.minX, y: cornerRadius))
            path.addArc(
                center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.minX + lenght, y: rect.minY))
            // TopRight corner
            path.move(to: CGPoint(x: rect.maxX - lenght, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 270),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + lenght))
            // BottomRight corner
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - lenght))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.maxX - lenght, y: rect.maxY))
            // BottomLeft corner
            path.move(to: CGPoint(x: rect.minX + lenght, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
            path.addArc(
                center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - lenght))
        }
    }
}
