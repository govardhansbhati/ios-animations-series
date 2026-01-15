import SwiftUI

struct SettingsView: View {
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Settings")
                    .font(.largeTitle).bold()
                
                Toggle("Enable Feature", isOn: .constant(true))
                Toggle("Another Option", isOn: .constant(false))
                
                Button("Close", action: onClose)
                    .padding()
                    .background(.ultraThinMaterial, in: Capsule())
            }
            .padding(32)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24))
            .padding()
        }
    }
}

