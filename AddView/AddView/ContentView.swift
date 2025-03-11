//
//  ContentView.swift
//  AddView
//
//  Created by govardhan singh on 11/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            ZStack {
                ExpandingView(expand: $isAnimating, direction: .bottom, symbolName: "note.text")
                ExpandingView(expand: $isAnimating, direction: .left, symbolName: "doc")
                ExpandingView(expand: $isAnimating, direction: .top, symbolName: "photo")
                ExpandingView(expand: $isAnimating, direction: .right, symbolName: "mic.fill")
                
                Image(systemName: "plus").font(.system(size: 40,weight: isAnimating ? .regular : .semibold, design: .rounded))
                    .foregroundStyle(isAnimating ? Color.white : Color.black)
                    .rotationEffect(isAnimating ? .degrees(45) : .degrees(0))
                    .scaleEffect(isAnimating ? 3 : 1)
                    .opacity(isAnimating ? 0.5 : 1)
                    .animation(Animation.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 1), value: UUID())
                    .onTapGesture {
                        isAnimating.toggle()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
