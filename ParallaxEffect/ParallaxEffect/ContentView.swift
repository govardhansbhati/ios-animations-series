//
//  ContentView.swift
//  ParallaxEffect
//
//  Created by govardhan singh on 24/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animate1 = false
    @State private var animate2 = false
    
    var body: some View {
        ZStack {
            // MARK: - background
            LinearGradient(gradient: Gradient(colors: [.green, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .colorInvert()
                .ignoresSafeArea()
            
            // MARK: - Title
            VStack {
                Text("Parallax Effect")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 80)
                
                // MARK: Wolf image
                VStack {
                    Image("lion")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .cornerRadius(25)
                        .shadow(color: .black, radius: 30, x: 5, y: 5)
                }
                .rotation3DEffect(.degrees(animate1 ? 13 : -12), axis: (x: animate1 ?  90 : -45, y: animate1 ? -45 : -90, z: 0))
                .animation(Animation.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: UUID())
                .onAppear() {
                    animate1.toggle()
                }.padding(30)
            }
        }
    }
}

#Preview {
    ContentView()
}
