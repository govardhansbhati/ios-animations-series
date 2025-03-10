//
//  BookPagesView.swift
//  BookLoader
//
//  Created by govardhan singh on 09/03/25.
//

import SwiftUI

struct BookPagesView: View {
    
    @State var leftEndDegree: Angle = .zero
    @State var leftYOffset: CGFloat = 0
    @State var rightEndDegree: Angle = .zero
    @State var rightYOffset: CGFloat = -20
    
    @State var pagesDegree: Angle = .zero
    @Binding var animationStarted: Bool
    let pageWidth: CGFloat  = 100
    let pageXOffset: CGFloat = -78
    let animationDuration: TimeInterval
    
    
    var body: some View {
        ZStack {
            Capsule().foregroundColor(.white).frame(width: pageWidth, height: 8)
                .offset(x: pageXOffset, y: leftYOffset)
                .rotationEffect(leftEndDegree)
                .animation(Animation.easeInOut(duration: animationDuration), value: UUID())
            
            Capsule().foregroundColor(.white).frame(width: pageWidth, height: 8)
                .offset(x: pageXOffset, y: rightYOffset)
                .rotationEffect(rightEndDegree)
                .animation(Animation.easeInOut(duration: animationDuration), value: UUID())
            
            ForEach(0..<13) { num in
                Capsule().foregroundColor(.white).frame(width: pageWidth, height: 8)
                    .offset(x: pageXOffset)
                    .rotationEffect(pagesDegree)
                    .animation(Animation.easeOut(duration: animationDuration).delay((animationDuration * 0.21) * Double(num)), value: UUID())
            }
        }
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { animationTimer in
                if (animationStarted) {
                    animatePages()
                    
                    
                    Timer.scheduledTimer(withTimeInterval: animationDuration * 10, repeats: true) { _ in
                        animatePages()
                    }
                    animationTimer.invalidate()
                }
            }
        }
    }
    
    // MARK: Functions
    func animatePages() {
        rightEndDegree = .degrees(180)
        pagesDegree  = .degrees(180)
        rightYOffset = 0
        
        //left page flipping over to the right
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2.7, repeats: false) { _ in
            leftYOffset = 20
            leftEndDegree = .degrees(180)
        }
        
        // flip left page back to the left
        Timer.scheduledTimer(withTimeInterval: animationDuration * 5, repeats: false) { _ in
            leftYOffset = 0
            leftEndDegree = .zero
        }
        
        // middles page turning to the left
        Timer.scheduledTimer(withTimeInterval: animationDuration * 5.25, repeats: false) { _ in
            pagesDegree  = .degrees(0)
        }
        
        
        //flip the right page to left
        Timer.scheduledTimer(withTimeInterval: animationDuration * 7, repeats: false) { _ in
            rightEndDegree = .degrees(0)
            rightYOffset = -20
        }
    }
}
