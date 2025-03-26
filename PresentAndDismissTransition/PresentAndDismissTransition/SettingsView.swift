//
//  SettingsView.swift
//  PresentAndDismissTransition
//
//  Created by govardhan singh on 26/03/25.
//
import SwiftUI

struct SettingsView: View {
    @State private var selection: Int = 1
    @State private var setData = Date()
    @State private var timeZoneOverride = true
    @State private var volume: Double = 25.0
    @State private var show: Bool
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    // Date Picker
                    Section(header: Text("Date and Time")) {
                        DatePicker(selection: $setData) {
                            Image(systemName: "calendar.circle")
                        }.foregroundStyle(Color.black)
                    }.listRowBackground(Color(UIColor.orange))
                    
                    // time zone toggle
                    Section(header: Text("Time zone override")) {
                        
                    }
                }
            }
        }
    }
}
