
//
//  Untitled.swift
//  Elevator
//
//  Created by govardhan singh on 19/03/25.
//

import SwiftUI
import Foundation

class DataModel: ObservableObject {
    @Published var doorsOpened = false
    @Published var floor1 = false
    @Published var floor2 = false
    @Published var goingUp = false
    @Published var doorOpenTimer: Timer? = nil
    @Published var chimesTimer: Timer? = nil
    @Published var doorSoundTimer: Timer? = nil
    
    func openDoors() {
        doorOpenTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: { _ in
            self.doorsOpened.toggle()
        })
    }
    
    func playChimeSound() {
        chimesTimer = Timer.scheduledTimer(withTimeInterval: 5.5, repeats: false, block: { _ in
            playSound(sound: "elevatorChime", type: "m4a")
        })
    }
    
    func playDoorOpenCloseSound(interval: TimeInterval) {
        doorSoundTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { _ in
            playSound(sound: "doorsOpenClose", type: "m4a")
        })
    }
    
    
    func floorNumber() {
        ///light up floor 1 as soon as the button is pressed, making sure floor 2 is not lit first
        if !floor2 {
            floor1.toggle()
        }
        ///check if the doors are opened, if not, open the doors and play the chime sound
        if !doorsOpened {
            openDoors()
            playChimeSound()
            
            ///going up - wait 4 seconds and turn on the floor 2 light, and turn off the floor 1 light
            if goingUp {
                withAnimation(Animation.default.delay(4.0)) {
                    floor2 = true
                    floor1 = false
                }
                ///once at the top, and the button is pressed again to go down, wait five seconds then turn off the floor 2 light and turn on the floor 1 light
                withAnimation(Animation.default.delay(5.0)) {
                    floor1 = true
                    floor2 = false
                    playDoorOpenCloseSound(interval: 8.5)
                }
                ///if not goingUp, keep the floor 2 light on for 5 seconds until the elevator doors close, and then turn it off and turn on the floor 1 lights, and play the chimes and door sound files.
            } else if !goingUp {
                withAnimation(Animation.default.delay(5.0)) {
                    floor1 = true
                    floor2 = false
                    playDoorOpenCloseSound(interval: 8.5)
                }
                withAnimation(Animation.default.delay(5.0)) {
                    floor2 = true
                    floor1 = false
                }
            }
        }
    }
    
    func stopTimers() {
        doorOpenTimer?.invalidate()
        doorOpenTimer = nil
        chimesTimer?.invalidate()
        chimesTimer = nil
        doorSoundTimer?.invalidate()
        doorSoundTimer = nil
    }
}
