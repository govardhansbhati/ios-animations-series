//
//  BookHold.swift
//  BookLoader
//
//  Created by govardhan singh on 09/03/25.
//
import SwiftUI

struct BookHoldView: Shape {
    
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX - 28
        let cY: CGFloat = rect.midY
        var path = Path()
        
        path.move(to: CGPoint(x: cX, y: cY))
        path.addLine(to: CGPoint(x: cX, y: cY + 12))
        path.addLine(to: CGPoint(x: cX + 56, y: cY + 12))
        path.addLine(to: CGPoint(x: cX + 56, y: cY))
        
        return path
    }
}
