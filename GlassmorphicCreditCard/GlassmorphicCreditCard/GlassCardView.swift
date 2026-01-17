import SwiftUI

struct GlassCardView: View {

    
    var body: some View {
        ZStack {
            // Main Card Material
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .frame(width: 350, height: 220)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            
            // "Rich" Depth - White Border Stroke
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.6),
                            .white.opacity(0.2),
                            .clear,
                            .white.opacity(0.2),
                            .white.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 350, height: 220)
            
            // Content
            VStack(alignment: .leading, spacing: 0) {
                // Top Row: Logo & Chip
                HStack {
                    Image(systemName: "simcard.2") // Using system symbol as chip
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                        )
                        .rotationEffect(.degrees(90))
                    
                    Spacer()
                    
                    // Simple text logo "VISA" style
                    Text("VISA")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .italic()
                        .foregroundStyle(.white)
                }
                .padding(.top, 25)
                .padding(.horizontal, 25)
                
                Spacer()
                
                // Card Number
                Text("4532  1234  5678  9010")
                    .font(.system(size: 22, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 25)
                
                Spacer()
                
                // Bottom Row: Name & Expiry
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CARD HOLDER")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Text("GOVARDHAN BHATI")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("EXPIRES")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white.opacity(0.7))
                        Text("12/29")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.bottom, 25)
                .padding(.horizontal, 25)
            }
            .frame(width: 350, height: 220)
        }
    }
}

#Preview {
    ZStack {
        Color.black
        GlassCardView()
    }
}
