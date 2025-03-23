//
//  ContentView.swift
//  Elevator
//
//  Created by govardhan singh on 18/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appData: DataModel
    let backgroundColor = Color(Color.black)
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            //MARK: Add the elevator and people
            ElevatorAndPeopleView(doorsOpened: $appData.doorsOpened)
            
            // MARK: Button
            GeometryReader { geo in
                Button(action: {
                    appData.doorsOpened.toggle()
                }) {
                    /// it the doors are opened make the button white, otherwise make it black
                    Circle().frame(width: 10, height: 10)
                        .foregroundStyle(appData.doorsOpened ? Color.white : Color.black)
                        .overlay {
                            Circle().stroke(Color.red, lineWidth: 1)
                        }
                        .padding(5)
                        .background(Color.black)
                        .cornerRadius(30)
                }
                .position(x: (geo.size.width / 33), y: (geo.size.height / 2))
            }
        }
    }
}

#Preview {
    ContentView(appData: DataModel())
}
