//
//  ContentView.swift
//  ParallaxEffect
//
//  Created by govardhan singh on 24/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var motion = MotionManager()
    
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
                .rotation3DEffect(.degrees(motion.xTilt * 50), axis: (x: -1, y: 0, z: 0))
                .rotation3DEffect(.degrees(motion.yTilt * 50), axis: (x: 0, y: 1, z: 0))
                .padding(30)
                .onTapGesture {
                    motion.resetCalibration()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
