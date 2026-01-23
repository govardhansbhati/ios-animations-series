//
//  ContentView.swift
//  iOSAnimations
//
//  Created by Govardhan Singh Bhati on 23/01/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Inline feedback animation") {
                    SyncStatusView()
                }
                
                NavigationLink("Quick option picker") {
                    QuickOptionPickerView()
                }
            }
            .navigationTitle("iOS Animations")
        }
    }
}

#Preview {
    ContentView()
}
