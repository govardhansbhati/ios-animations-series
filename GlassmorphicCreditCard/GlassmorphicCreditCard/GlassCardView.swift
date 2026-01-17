import SwiftUI

struct GlassCardView: View {
    
    var body: some View {
        ZStack {
            // MARK: - Metallic Base
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.8, green: 0.82, blue: 0.85), // Light Silver
                            Color(red: 0.6, green: 0.65, blue: 0.7),  // Darker Steel
                            Color(red: 0.85, green: 0.88, blue: 0.9)  // Highlight
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // Brushed Metal Texture Effect (Simulated with Gradient)
                    LinearGradient(
                        colors: [.black.opacity(0.1), .clear, .white.opacity(0.1), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .blendMode(.overlay)
                )
                .frame(width: 350, height: 220)
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
            

            
            // MARK: - Metallic Border
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.8),
                            .gray.opacity(0.5),
                            .white.opacity(0.8),
                            .gray.opacity(0.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 350, height: 220)
            
            // MARK: - Content (Etched Look)
            VStack(alignment: .leading, spacing: 0) {
                // Top Row: Logo & Chip
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(colors: [.yellow.opacity(0.8), .orange], startPoint: .top, endPoint: .bottom))
                            .frame(width: 45, height: 35)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.black.opacity(0.2), lineWidth: 1)
                            .frame(width: 45, height: 35)
                        
                        Image(systemName: "simcard")
                            .font(.system(size: 20))
                            .foregroundStyle(.black.opacity(0.4))
                            .rotationEffect(.degrees(90))
                    }
                    
                    Spacer()
                    
                    Text("PLATINUM")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.black.opacity(0.6), .black.opacity(0.3)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .white.opacity(0.5), radius: 1, x: 0, y: 1) // Etched effect
                }
                .padding(.top, 25)
                .padding(.horizontal, 25)
                
                Spacer()
                
                // Card Number - Embossed
                Text("4532  1234  5678  9010")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.black.opacity(0.7), .black.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .white.opacity(0.6), radius: 1, x: 1, y: 1)
                    .padding(.horizontal, 25)
                
                Spacer()
                
                // Bottom Row
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CARD HOLDER")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.black.opacity(0.5))
                        
                        Text("GOVARDHAN BHATI")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.black.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("EXPIRES")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.black.opacity(0.5))
                        Text("12/29")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.black.opacity(0.7))
                    }
                    
                    Spacer()
                        .frame(width: 20)
                    
                    // VISA Logo (Dark)
                    Text("VISA")
                        .font(.system(size: 22, weight: .heavy, design: .serif))
                        .italic()
                        .foregroundStyle(
                            LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
                        )
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
