//
//  ContentView.swift
//  WeatherAnimation
//
//  Created by govardhan singh on 12/03/25.
//

import SwiftUI

struct ContentView: View {
    
    // array to hold the three weekly data
    @State var dataArray = [DataModel.temperature, DataModel.precipitation, DataModel.wind]
    
    var capsuleWidth: CGFloat = 14
    @State private var pickerSelection = 0
    @State private var isOn = false
    @State private var animationTemp = false
    @State private var animationPrecip = false
    @State private var animationWind = false
    @State private var animateTempImage = false
    @State private var animatePrecipImage = false
    @State private var animateWindImage = false
    
    init() {
        // The foreGround color of each selected segment
        UISegmentedControl.appearance().selectedSegmentTintColor = .black
        
        // the color for the title for the selected segment
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        // the color for the title for the unselected segment
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    var body: some View {
        ZStack  {
            Color(.sRGB, red: 255/255, green: 195/255, blue: 0/255, opacity: 1).ignoresSafeArea()
            VStack {
                // Title
                Text("Weather").font(.system(size: 40)).fontWeight(.medium).font(.title)
                    .shadow(color: .black, radius: 1, x: 0 , y: 0)
                
                // MARK: Picker Segment
                PickerView(pickerSelection: $pickerSelection)
                    .onReceive([pickerSelection].publisher.first()) { value in
                        
                        if value == 0 {
                            // set the text labels for each segment on the picker
                            animationTemp = true
                            animationPrecip = false
                            animationWind = false
                        
                            // set the image for each segment on the picker
                            animateTempImage = true
                            animatePrecipImage = false
                            animateWindImage = false
                        }
                        
                        
//                            // set the text labels for each segment on the picker
//                            animationTemp = value == 0
//                            animationPrecip = value == 1
//                            animationWind = value == 2
//                        
//                            // set the image for each segment on the picker
//                            animateTempImage = value == 0
//                            animatePrecipImage = value == 1
//                            animateWindImage = value == 2
                    }
                
                //MARK: Weekly Graph
                    ZStack {
                        
                        HStack(spacing: 20) {
                            WeeklyGraph(dayHeight: dataArray[pickerSelection][0], width: (350) / capsuleWidth)
                            WeeklyGraph(dayHeight: dataArray[pickerSelection][1], width: (350) / capsuleWidth)
                            WeeklyGraph(dayHeight: dataArray[pickerSelection][2], width: (350) / capsuleWidth)
                            WeeklyGraph(dayHeight: dataArray[pickerSelection][3], width: (350) / capsuleWidth)
                            WeeklyGraph(dayHeight: dataArray[pickerSelection][4], width: (350) / capsuleWidth)
                            WeeklyGraph(dayHeight: dataArray[pickerSelection][5], width: (350) / capsuleWidth)
                            WeeklyGraph(dayHeight: dataArray[pickerSelection][6], width: (350) / capsuleWidth)
                        }
                        
                        .animation(.spring(response: 0.9, dampingFraction: 0.6), value: UUID())
                        
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 1).shadow(color: .black, radius: 8, x: 3, y: 3)
                            .padding(.horizontal, 10)
                    }
                GeometryReader { geo in
                    VStack {
                        if animationTemp {
                            Text("Temperature").fontWeight(.medium).font(.title).shadow(color: .black, radius: 1, x:0, y: 2)
                                .transition(AnyTransition.offset(x: 300))
                                .animation(Animation.easeOut(duration: 1.0), value: UUID())
                        }
                        
                        if animationPrecip {
                            Text("Precipitation").fontWeight(.medium).font(.title).shadow(color: .black, radius: 1, x:0, y: 2)
                                .transition(AnyTransition.offset(x: -300))
                                .animation(Animation.easeOut(duration: 1.0), value: UUID())
                        }
                        
                        if animationWind {
                            Text("Wind").fontWeight(.medium).font(.title).shadow(color: .black, radius: 1, x:0, y: 2)
                                .transition(AnyTransition.offset(x: 300))
                                .animation(Animation.easeOut(duration: 1.0), value: UUID())
                        }
                    }.position(x:geo.size.width * 0.5, y: geo.size.height * 0.2)
                    
                    VStack {
                        if animateTempImage {
                            Image("tempImage").resizable().aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                                .position(y: geo.size.height / 2).transition(AnyTransition.offset(y: 300))
                                .animation(Animation.easeOut(duration: 1.0), value: UUID())
                        }
                        
                        if animatePrecipImage {
                            Image("precip").resizable().aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                                .position(y: geo.size.height / 2).transition(AnyTransition.offset(x: 300))
                                .animation(Animation.easeOut(duration: 1.0), value: UUID())
                        }
                        
                        if animateWindImage {
                            Image("wind").resizable().aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                                .position(y: geo.size.height / 2).transition(AnyTransition.offset(x: -300))
                                .animation(Animation.easeOut(duration: 1.0), value: UUID())
                        }
                    }.position(x: geo.size.width, y: geo.size.height * 0.6)
                }
            }
        }
    }
}

struct WeeklyGraph: View {
    var dayHeight: DataModel
    var width: CGFloat
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Capsule().opacity(0.3)
                    .frame(width: width + 2, height: 200)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2)
                        .shadow(color: Color.black,radius: 8, x: 0, y: 0))
                Capsule()
                    .frame(width: width, height: dayHeight.data * 200)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 20).fill(Color.white).opacity(0.9)
                    })
                    .padding(.bottom, 8)
                Text(dayHeight.day).font(.system(size: 14))
            }
        }
    }
}

#Preview {
    ContentView()
}
