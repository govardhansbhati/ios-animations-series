//
//  ContentView.swift
//  LightSwitch
//
//  Created by govardhan singh on 10/03/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Variables
    let appWidth = UIScreen.main.bounds.width
    let appHeight = UIScreen.main.bounds.height
    let animationDuration: TimeInterval = 0.35
    @State var xScale: CGFloat = 2
    @State var yScale: CGFloat = 0.4
    @State var yOffset: CGFloat = UIScreen.main.bounds.height * 0.8
    @State var isOff: Bool = true
    
    
    var body: some View {
        ZStack {
            Color.black
            // MARK: CircleView
            Circle().fill(Color.yellow)
                .scaleEffect(CGSize(width: xScale, height: yScale))
                .offset(y: yOffset)
            
            // MARK: Arrow and label at top
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "arrow.left").foregroundColor(isOff ? .white : .black)
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    Spacer()
                    Text("Study Room").font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(isOff ? .white : .black).offset(x: -12)
                    Spacer()
                }
                .padding([.top, .bottom], 24)
                Spacer()
            }
            .offset(y: 32)
            .padding([.leading, .trailing], 24)
            
            // MARK: Grey capsule for the end of the rope
            Capsule(style: .continuous).foregroundStyle(Color.gray).frame(width: 52, height: appHeight * 0.25 + 6)
            
                .opacity(0.275)
                .offset(x: appWidth / 2 - 48, y: 16)
            
            // Rope and Ball
            ZStack {
                Capsule()
                    .frame(width: 3, height: isOff ? appHeight * 0.41 : appHeight * 0.625)
                    .foregroundStyle(Color.white)
                Circle().fill(Color.white).frame(width: 42)
                    .offset(y: isOff ? appHeight * 0.225 : appHeight * 0.25 + 42)
                    .onTapGesture {
                        toggleAllLight()
                    }
            }.offset(x: appWidth / 2 - 48, y: -appHeight / 2)
                .frame(height: 0, alignment: .top)
            
        }
        .animation(Animation.spring(dampingFraction: 0.65).speed(1.25), value: UUID())
        .edgesIgnoringSafeArea(.all)
    }
    
    func toggleAllLight() {
        if isOff {
            withAnimation(Animation.easeIn(duration: animationDuration)) {
                xScale = 4
                yScale = 2
                yOffset = UIScreen.main.bounds.height * 0.8
            }
        } else {
            withAnimation(Animation.easeIn(duration: animationDuration)) {
                xScale = 0.4
                yScale = 2
                yOffset = UIScreen.main.bounds.height * 0.8
            }
        }
        isOff.toggle()
    }
}

#Preview {
    ContentView()
}
