//
//  ContentView.swift
//  PresentAndDismissTransition
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI

struct ContentView: View {
    let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
    
    @State private var buttonFrame: CGRect = CGRect(
            x: UIScreen.main.bounds.width / 2,
            y: UIScreen.main.bounds.height, // Start at bottom
            width: 100,
            height: 50
        )
        
        @State private var squeezeX: CGFloat = 1 // Start squeezed
        @State private var squeezeY: CGFloat = 1
        @State private var translateY: CGFloat = 1 // Start translated
    // UI
    @State private var isShowingSettings = false
    
    var body: some View {
            ZStack {
                background
                
                VStack {
                    Spacer()
                    customizeButton
                }
                
                genieLayer
            }
            .onPreferenceChange(ButtonFrameKey.self) { newFrame in
                // Only update if the frame is valid (not zero)
                if newFrame.width > 0 {
                    buttonFrame = newFrame
                }
            }
        }
}

private extension ContentView {
    
    var background: some View {
        LinearGradient(
            colors: [.black, .blue.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var customizeButton: some View {
        Button("Customize") {
            openSettings()
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 18)
        .background(.ultraThinMaterial, in: Capsule())
        .background(
            GeometryReader {
                Color.clear.preference(
                    key: ButtonFrameKey.self,
                    value: $0.frame(in: .global)
                )
            }
        )
        .opacity(isShowingSettings ? 0 : 1)
        .animation(.easeInOut, value: isShowingSettings)
        .padding(.bottom, 60)
    }
}

private extension ContentView {
    
    var genieLayer: some View {
            ZStack {
                if isShowingSettings {
                    SettingsView {
                        closeSettings()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea() // Critical for coordinate matching
                }
            }
            .modifier(
                GenieEffect(
                    buttonFrame: buttonFrame,
                    squeezeX: squeezeX,
                    squeezeY: squeezeY,
                    translateY: translateY
                )
            )
            // Hide view when fully collapsed to avoid glitches
            .opacity(translateY > 0.99 ? 0 : 1)
            .allowsHitTesting(isShowingSettings)
            .zIndex(10)
        }

}

private extension ContentView {
    
        
    func openSettings() {
        // Start state: Fully collapsed into button
        squeezeX = 1
        squeezeY = 1
        translateY = 1
        
        isShowingSettings = true
        
        // 1. Rise up (translate)
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            translateY = 0
        }
        
        // 2. Unfold (squeeze)
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
            squeezeX = 0
            squeezeY = 0
        }
    }
    
    func closeSettings() {
        // 1. Fold (squeeze)
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            squeezeX = 1
            squeezeY = 1
        }
        
        // 2. Sink (translate)
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
            translateY = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isShowingSettings = false
        }
    }
}

// MARK: - Reference Genie Effect Modifier

// MARK: - Updated Genie Modifier
// MARK: - Fixed Genie Modifier (Swift)
struct GenieEffect: ViewModifier {
    
    var buttonFrame: CGRect
    var squeezeX: CGFloat
    var squeezeY: CGFloat
    var translateY: CGFloat
    
    func body(content: Content) -> some View {
        content.distortionEffect(
            Shader(
                function: .init(library: .default, name: "genie"),
                arguments: [
                    .boundingRect,
                    // Pass specific float values to avoid SIMD/Float errors
                    .float(Float(buttonFrame.origin.x)),
                    .float(Float(buttonFrame.origin.y)),
                    .float(Float(buttonFrame.width)),
                    .float(Float(buttonFrame.height)),
                    
                    .float(squeezeX),
                    .float(squeezeY),
                    .float(translateY)
                ]
            ),
            maxSampleOffset: CGSize(width: 500, height: 800)
        )
    }
}
// 1. Preference Key to capture frames
struct ButtonFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// Button Scale Effect
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
