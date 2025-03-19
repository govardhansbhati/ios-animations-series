//
//  ElevatorApp.swift
//  Elevator
//
//  Created by govardhan singh on 18/03/25.
//

import SwiftUI

@main
struct ElevatorApp: App {
    @StateObject private var appData = DataModel()
    var body: some Scene {
        WindowGroup {
            ContentView(appData: appData)
        }
    }
}
