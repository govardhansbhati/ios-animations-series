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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
