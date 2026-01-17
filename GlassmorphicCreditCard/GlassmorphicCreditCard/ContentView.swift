//
//  ContentView.swift
//  GlassmorphicCreditCard
//
//  Created by Govardhan Singh Bhati on 17/01/26.
//

import SwiftUI

@MainActor
struct ContentView: View {
    
    nonisolated enum Phase: Equatable {
        case stack
        case rotated
        case ring
    }
    
    @State private var phase: Phase = .stack
    @Namespace private var ns
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                BackgroundOrbsView()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    let layout = phase == .ring ? AnyLayout(HStackLayout(spacing: -40)) : AnyLayout(ZStackLayout())
                    
                    layout {
                        ForEach(0..<6, id: \.self) { index in
                            cardView(for: index)
                        }
                    }
                    .frame(minWidth: geo.size.width, minHeight: geo.size.height)
                }
                .scrollDisabled(phase != .ring)
            }
        }
    }
    
    @ViewBuilder
    func cardView(for index: Int) -> some View {
        let currentPhase = self.phase
        GlassCardView()
            .rotationEffect(.degrees(phase == .stack ? 0 : 90))
            .frame(width: phase == .ring ? 260 : 350, height: phase == .ring ? 400 : 220)
            .scaleEffect(
                phase == .stack ? (1 - CGFloat(2 - index) * 0.08) : 1.0
            )
            .offset(y: phase == .stack ? CGFloat(2 - index) * -35 : 0)
            .zIndex(phase == .stack ? Double(index) : 0) // Stack order vs Natural order
            .opacity(phase != .ring && index >= 3 ? 0 : 1) // Hide extra cards in stack
            .scrollTransition(.interactive, axis: .horizontal) { view, transitionPhase in
                view
                    .rotation3DEffect(
                        Angle.degrees(currentPhase == .ring ? transitionPhase.value * 60 : 0),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.7
                    )
                    .scaleEffect(currentPhase == .ring && !transitionPhase.isIdentity ? 0.82 : 1)
                    .opacity(currentPhase == .ring && !transitionPhase.isIdentity ? 0.6 : 1)
            }
            .onTapGesture {
                if phase == .ring {
                    collapseToStack()
                } else {
                    expandToRing()
                }
            }
    }

    func expandToRing() {
        // Step 1: Rotate -> Wait -> Expand
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            phase = .rotated
        } completion: {
            // Step 2: Expand to Ring (Chained strictly after rotation finishes)
            withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                phase = .ring
            }
        }
    }
    
    func collapseToStack() {
        // Step 1: Collapse to Rotated Stack
        withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
            phase = .rotated
        } completion: {
            // Step 2: Rotate back to Portrait
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                phase = .stack
            }
        }
    }
}

#Preview {
    ContentView()
}

