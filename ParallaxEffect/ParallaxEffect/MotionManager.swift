//
//  MotionManager.swift
//  ParallaxEffect
//
//  Created by govardhan singh on 28/05/24.
//

import Foundation
import CoreMotion
import SwiftUI

class MotionManager: ObservableObject {
    @Published var xTilt: Double = 0.0
    @Published var yTilt: Double = 0.0
    
    private var motionManager: CMMotionManager
    
    // Baselines for auto-calibration
    private var baselineX: Double = 0.0
    private var baselineY: Double = 0.0
    private var isInitialized = false
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // 60 Hz
        startMotionUpdates()
    }
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let self = self, let data = data else { return }
                
                let currentX = data.gravity.x
                let currentY = data.gravity.y
                
                // Initialize baseline on first frame
                if !self.isInitialized {
                    self.baselineX = currentX
                    self.baselineY = currentY
                    self.isInitialized = true
                }
                
                // Smoothly update baseline (Low-pass filter)
                // This allows the "center" to drift to the new holding position over time
                let alpha = 0.02 // Adjust factor for speed of re-centering (lower = slower)
                self.baselineX = self.baselineX * (1 - alpha) + currentX * alpha
                self.baselineY = self.baselineY * (1 - alpha) + currentY * alpha
                
                withAnimation(.easeOut(duration: 0.1)) {
                    // Calculate tilt as deviation from baseline
                    self.xTilt = currentX - self.baselineX
                    self.yTilt = currentY - self.baselineY
                }
            }
        }
    }
    
    // Manual reset if needed (though auto-calibration makes this less critical)
    func resetCalibration() {
        self.isInitialized = false
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
