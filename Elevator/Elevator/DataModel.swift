
//
//  Untitled.swift
//  Elevator
//
//  Created by govardhan singh on 19/03/25.
//

import SwiftUI
import Foundation

class DataModel: ObservableObject {
    @Published var doorOpened = false
    @Published var floor1 = false
    @Published var floor2 = false
    @Published var gettingUp = false
    @Published var doorOpenTimer: Timer? = nil
    @Published var chimesTimer: Timer? = nil
    @Published var doorSoundTimer: Timer? = nil
    
    func openDoors() {
        doorOpenTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: { _ in
            self.doorOpened.toggle()
        })
    }
    
    func playChimeSound() {
        chimesTimer = Timer.scheduledTimer(withTimeInterval: 5.5, repeats: false, block: { _ in
            playSound(sound: "elevatorChime", type: "m4a")
        })
    }
    
    func playDoorOpenCloseSound() {
        doorSoundTimer = Timer.scheduledTimer(withTimeInterval: 5.5, repeats: false, block: { _ in
            playSound(sound: "doorsOpenClose", type: "m4a")
        })
    }
    
    func floorNumber() {
        
    }
}
