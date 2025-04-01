//
//  ContentView.swift
//  PresentAndDismissTransition
//
//  Created by govardhan singh on 26/03/25.
//

import SwiftUI

struct ContentView: View {
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

struct PresentAndDismiss: GeometryEffect {
    var offSetValue: Double
    var animatableData: Double {
        get { offSetValue }
        set { offSetValue = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let rotationOffset = offSetValue
        let angleOfRotation = CGFloat(Angle(degrees: 95 * (1 - rotationOffset)).radians)
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1 / max(size.width, size.height)
        transform3D = CATransform3DRotate(transform3D, angleOfRotation, 1, 0, 0)
        transform3D = CATransform3DTranslate(transform3D, -size.width/2.0, -size.height/2.0, 0)
        let transformAffine1 = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height/2.0))
        let transformAffine2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(offSetValue * 2), y: CGFloat(offSetValue * 2)))
        
        if offSetValue <= 0.5 {
            return ProjectionTransform(transform3D).concatenating(transformAffine2).concatenating(transformAffine1)
        } else {
            return ProjectionTransform(transform3D).concatenating(transformAffine1)
        }
    }
}

struct OpenSettingsView : View {
    var body: some View {
        VStack {
            ZStack {
                //
            }
        }
    }
}

#Preview {
    ContentView()
}
