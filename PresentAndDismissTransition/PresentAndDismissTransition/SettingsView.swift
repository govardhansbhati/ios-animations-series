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
                        Toggle(isOn: $timeZoneOverride) {
                            HStack {
                                Image(systemName: "timer")
                                Text("Override")
                            }.foregroundStyle(Color.black)
                        }
                    }.listRowBackground(Color(UIColor.orange))
                    
                    //alarm volume
                    Section(header: Text("Alarm Volume")) {
                        Text("Volume \(String(format: "%.0f", volume as Double)) Decibels").foregroundStyle(Color.black)
                        Slider(value: $volume, in: 0...100) { _  in
                            // Code to run when slider is moved
                        }
                    }.listRowBackground(Color(UIColor.orange))
                    
                    // repeat alarm
                    Section(header: Text("Repeat Alarm")) {
                        Picker(selection: $selection, label: Text("Repeat Alarm:")) {
                            Text("No Repeat").tag(1)
                            Text("Repeat Once").tag(2)
                            Text("Repeat Twice").tag(3)
                        }.foregroundStyle(Color.black)
                    }.listRowBackground(Color(UIColor.orange))
                    
                    //save  button
                    Button(action: {
                        withAnimation {
                            self.show = false
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Save")
                            Spacer()
                        }
                    }.listRowBackground(Color(UIColor.orange))
                }
                .foregroundStyle(Color.white)
                .listStyle(InsetGroupedListStyle())
            }.frame(width: 350, height: 625)
                .cornerRadius(20)
            
            Text("Settings").offset(y: -250)
                .foregroundStyle(Color.black)
                .font(.title)
        }
    }
}
