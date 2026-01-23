import SwiftUI

// MARK: - Models
enum SyncState {
    case syncing
    case failed
}

// MARK: - Main View
struct SyncStatusView: View {
    @State private var currentState: SyncState = .syncing
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            // Modern Background
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    if currentState == .syncing {
                        SyncingCapsule(animation: animation)
                            .transition(.scale(scale: 0.9).combined(with: .opacity))
                    } else {
                        FailedCapsule(animation: animation)
                            .transition(.scale(scale: 0.9).combined(with: .opacity))
                        
                        RetryButton(action: retrySync)
                            .transition(.scale.combined(with: .opacity).animation(.bouncy(duration: 0.4).delay(0.1)))
                    }
                }
                // Smooth layout transition
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentState)
                
                Spacer()
            }
        }
        .onAppear {
            startFakeSync()
        }
    }
    
    // MARK: - Logic
    func startFakeSync() {
        currentState = .syncing
        // Simulate sync failure after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                currentState = .failed
            }
        }
    }
    
    func retrySync() {
        withAnimation {
            currentState = .syncing
        }
        // Restart the fake sync cycle
        startFakeSync()
    }
}

// MARK: - Shared Components

struct RotaryText: View {
    var state: SyncState
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Sync")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(state == .syncing ? .primary : Color.red)
                .matchedGeometryEffect(id: "textPrefix", in: animation)
            
            // Suffix with rotary animation
            ZStack {
                if state == .syncing {
                    Text("ing")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                } else {
                    Text(" Failed")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.red)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                }
            }
            // Clip to mask the sliding text for a "wheel" effect
            .clipped()
        }
        // Force the text to animate its changes
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: state)
        .fixedSize()
    }
}

// MARK: - Components

struct SyncingCapsule: View {
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 16) {
            DottedLoader()
                .frame(width: 22, height: 22)
                .matchedGeometryEffect(id: "statusIcon", in: animation)
            
            RotaryText(state: .syncing, animation: animation)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background {
            ZStack {
                Capsule()
                    .fill(.regularMaterial) // Glassmorphic feel
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .matchedGeometryEffect(id: "capsuleBackground", in: animation)
                
                // Shimmer Overlay
                Capsule()
                    .fill(.clear)
                    .overlay {
                        ShimmerView()
                            .mask(Capsule())
                    }
                    .matchedGeometryEffect(id: "capsuleShimmer", in: animation)
            }
        }
    }
}

struct FailedCapsule: View {
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.octagon.fill")
                .font(.title3)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.red)
                .matchedGeometryEffect(id: "statusIcon", in: animation)
            
            RotaryText(state: .failed, animation: animation)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background {
            Capsule()
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                .matchedGeometryEffect(id: "capsuleBackground", in: animation)
        }
    }
}

struct RetryButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background {
                    Circle()
                        .fill(Color.black)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
        }
    }
}

// MARK: - Animations

struct DottedLoader: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Central Dot
            Circle()
                .fill(Color.primary.opacity(0.8))
                .frame(width: 4, height: 4)
            
            // Outer Circle
            CircleDots(count: 12)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: isAnimating)
            
            // Inner Circle - Rotating Opposite
            CircleDots(count: 8, scale: 0.6)
                .rotationEffect(.degrees(isAnimating ? -360 : 0))
                .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct CircleDots: View {
    var count: Int
    var scale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let radius = width / 2
            
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(Color.primary.opacity(0.8))
                    .frame(width: 3.5, height: 3.5)
                    .position(
                        x: radius + (radius * scale * cos(angle(for: index))),
                        y: radius + (radius * scale * sin(angle(for: index)))
                    )
            }
        }
    }
    
    func angle(for index: Int) -> CGFloat {
        return CGFloat(index) * 2 * .pi / CGFloat(count)
    }
}

// Shimmer Effect
struct ShimmerView: View {
    @State private var start = UnitPoint(x: -1, y: 0.5)
    @State private var end = UnitPoint(x: 0, y: 0.5)
    
    var body: some View {
        LinearGradient(
            colors: [
                .clear,
                .white.opacity(0.5),
                .clear
            ],
            startPoint: start,
            endPoint: end
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: false)
                .delay(0.5)
            ) {
                start = UnitPoint(x: 1, y: 0.5)
                end = UnitPoint(x: 2, y: 0.5)
            }
        }
    }
}

#Preview {
    SyncStatusView()
}
