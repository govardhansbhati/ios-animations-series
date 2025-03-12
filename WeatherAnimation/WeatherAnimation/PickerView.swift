

//
//  PickerView.swift
//  WeatherAnimation
//
//  Created by govardhan singh on 12/03/25.
//
import SwiftUI

struct PickerView: View {
    @Binding var pickerSelection: Int
    
    var body: some View {
        Picker(selection: self.$pickerSelection, label: Text("")) {
            Text("Temperature 🌡️").tag(0)
            Text("Precipitation ⛆").tag(1)
            Text("Temperature 💨").tag(2)
        }.pickerStyle(SegmentedPickerStyle())
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 2)
                .shadow(color: Color.black, radius: 8, x: 0 , y: 0))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
    }
}
