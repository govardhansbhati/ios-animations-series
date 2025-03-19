//
//  ContentView.swift
//  Elevator
//
//  Created by govardhan singh on 18/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appData: DataModel
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
    ContentView(appData: DataModel())
}
