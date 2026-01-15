
import SwiftUI

struct MapDetailView: View {
    @Environment(\.dismiss) var dismiss
    var mapImage: UIImage?
    @State private var isUnrolled = false
    
    // Wood Texture Colors
    let woodColor = Color(red: 0.4, green: 0.25, blue: 0.15)
    let woodGrain = Color(red: 0.35, green: 0.2, blue: 0.1)
    
    var body: some View {
        ZStack {
            // Background: Wooden Table Effect
            woodColor
                .ignoresSafeArea()
                .overlay(
                    // Simple grain effect using noise or gradient if needed, 
                    // for now just a linear gradient to simulate light
                    LinearGradient(
                        gradient: Gradient(colors: [woodColor, woodGrain, woodColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.8)
                )
            
            // Map
            PaperMapUnrollView(
                isUnrolled: $isUnrolled,
                mapImage: mapImage
            )
            .ignoresSafeArea()
            .padding(.top, 15) // Reduced space
            .padding(.bottom, 15)
            
            // Close Button
            VStack {
                Spacer()
                Button(action: {
                    // Roll up first
                    withAnimation(.spring()) {
                        isUnrolled = false
                    }
                    
                    // Dismiss after animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        dismiss()
                    }
                }) {
                    Text("Close Map")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // We manage back navigation
        .onAppear {
            // Auto-Unroll after a brief delay for transition to finish
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isUnrolled = true
                }
            }
        }
        .onDisappear {
            isUnrolled = false
        }
    }
}
