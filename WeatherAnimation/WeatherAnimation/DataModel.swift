//
//  DataModel.swift
//  WeatherAnimation
//
//  Created by govardhan singh on 12/03/25.
//

import Foundation
import SwiftUI

struct DataModel {
    let day: String
    let data: CGFloat
    
    // Weekly temperature data
    static let temperature: [DataModel] = [
        .init(day: "Su", data: 0.9),
        .init(day: "M", data: 0.7),
        .init(day: "T", data: 0.5),
        .init(day: "W", data: 0.7),
        .init(day: "TH", data: 0.8),
        .init(day: "F", data: 0.34),
        .init(day: "Sa", data: 0.92),
    ]
    
    // Weekly Precipitation Data
    static let precipitation: [DataModel] = [
        .init(day: "Su", data: 0.2),
        .init(day: "M", data: 0.3),
        .init(day: "T", data: 0.5),
        .init(day: "W", data: 0.2),
        .init(day: "TH", data: 0.8),
        .init(day: "F", data: 0.5),
        .init(day: "Sa", data: 0.9),
    ]
    
    // Weekly wind percentage data
    static let wind: [DataModel] = [
        .init(day: "Su", data: 0.59),
        .init(day: "M", data: 0.77),
        .init(day: "T", data: 0.35),
        .init(day: "W", data: 0.77),
        .init(day: "TH", data: 0.08),
        .init(day: "F", data: 0.3),
        .init(day: "Sa", data: 0.22),
    ]
}
