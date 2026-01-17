import SwiftUI

// MARK: - Models
struct SearchResult: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

// MARK: - Mock Data
let mockResults: [SearchResult] = [
    .init(icon: "person.circle.fill", title: "Alice M.", subtitle: "Sent $50 • 2m ago"),
    .init(icon: "cart.fill", title: "Grocery Store", subtitle: "Spent $120 • 2h ago"),
    .init(icon: "airplane", title: "Flight to NYC", subtitle: "Upcoming • Tomorrow"),
    .init(icon: "doc.text.fill", title: "Invoice #002", subtitle: "Received • Yesterday"),
    .init(icon: "star.fill", title: "Favorites", subtitle: "3 New Items")
]

// MARK: - Animation State
enum SearchPhase {
    case idle
    case absorbing
    case pouringBack
}

struct Checkpoint: Equatable {
    var offset: CGSize = .zero
    var scale: CGFloat = 1
    var opacity: Double = 1
    var rotation: Double = 0
}

struct AbsorptionVector {
    let arcX: CGFloat
    let rotation: Double
}

// MARK: - Main View
struct AbsorptionSearchBar: View {
    
    @State private var searchText = ""
    @State private var phase: SearchPhase = .idle
    @State private var searchBarScale: CGSize = .init(width: 1, height: 1)
    
    @State private var searchBarFrame: CGRect = .zero
    @State private var itemFrames: [UUID: CGRect] = [:]
    @State private var vectors: [UUID: AbsorptionVector] = [:]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                searchBar
                    .background(
                        GeometryReader {
                            Color.clear.preference(
                                key: SearchBarFrameKey.self,
                                value: $0.frame(in: .global)
                            )
                        }
                    )
                    .zIndex(10)
                
                ZStack {
                    if phase == .idle {
                        staticList
                    } else {
                        animatedList
                    }
                }
                
                Spacer()
            }
            .padding(.top, 60)
        }
        .onAppear {
            vectors = Dictionary(uniqueKeysWithValues: mockResults.map {
                (
                    $0.id,
                    AbsorptionVector(
                        arcX: CGFloat.random(in: -40...40),
                        rotation: Double.random(in: -12...12)
                    )
                )
            })
        }
        .onPreferenceChange(SearchBarFrameKey.self) { searchBarFrame = $0 }
        .onPreferenceChange(ItemFrameKey.self) { itemFrames = $0 }
    }
}

// MARK: - Search Bar
private extension AbsorptionSearchBar {
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search transactions", text: $searchText)
                .textFieldStyle(.plain)
                .opacity(phase == .idle ? 1 : 0)
            
            if phase != .idle {
                Button(action: cancelSearch) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(Capsule())
        .scaleEffect(searchBarScale)
        .scaleEffect(phase != .idle ? 1.05 : 1)
        .shadow(color: .black.opacity(phase != .idle ? 0.25 : 0.1), radius: 16, y: 6)
        .padding(.horizontal)
        .onTapGesture { startSearch() }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: phase)
    }
}

// MARK: - Static List
private extension AbsorptionSearchBar {
    
    var staticList: some View {
        VStack(spacing: 16) {
            ForEach(mockResults) { item in
                ResultRow(item: item)
                    .background(
                        GeometryReader {
                            Color.clear.preference(
                                key: ItemFrameKey.self,
                                value: [item.id: $0.frame(in: .global)]
                            )
                        }
                    )
            }
        }
        .padding(.top, 24)
    }
}

// MARK: - Animated List (Absorb + Pour Back)
private extension AbsorptionSearchBar {
    
    var animatedList: some View {
        ZStack {
            ForEach(Array(mockResults.enumerated()), id: \.element.id) { (index) in
                
                let frame = itemFrames[item.id] ?? .zero
                let vector = vectors[item.id]
                
                let start = CGPoint(x: frame.midX, y: frame.midY)
                let end = CGPoint(x: searchBarFrame.midX, y: searchBarFrame.midY)
                
                let dx = end.x - start.x
                let dy = end.y - start.y
                
                let delay = Double(mockResults.count - index) * 0.05
                
                KeyframeAnimator(
                    initialValue: Checkpoint(
                        offset: phase == .pouringBack ? CGSize(width: dx, height: dy) : .zero,
                        scale: phase == .pouringBack ? 0.01 : 1,
                        opacity: 1,
                        rotation: vector?.rotation ?? 0
                    ),
                    trigger: phase
                ) { value in
                    ResultRow(item: item)
                        .scaleEffect(value.scale)
                        .rotationEffect(.degrees(value.rotation))
                        .opacity(value.opacity)
                        .offset(value.offset)
                } keyframes: { _ in
                    
                    if phase == .absorbing {
                        
                        KeyframeTrack(\.offset) {
                            LinearKeyframe(.zero, duration: delay)
                            CubicKeyframe(
                                CGSize(width: vector?.arcX ?? 0, height: dy * 0.25),
                                duration: 0.25
                            )
                            CubicKeyframe(
                                CGSize(width: dx, height: dy),
                                duration: 0.45
                            )
                        }
                        
                        KeyframeTrack(\.scale) {
                            LinearKeyframe(1, duration: delay)
                            CubicKeyframe(0.25, duration: 0.45)
                            LinearKeyframe(0.01, duration: 0.05)
                        }
                        
                        KeyframeTrack(\.opacity) {
                            LinearKeyframe(1, duration: delay + 0.5)
                            LinearKeyframe(0, duration: 0.1)
                        }
                        
                    } else if phase == .pouringBack {
                        
                        KeyframeTrack(\.offset) {
                            LinearKeyframe(CGSize(width: dx, height: dy), duration: delay)
                            CubicKeyframe(
                                CGSize(width: vector?.arcX ?? 0, height: dy * 0.3),
                                duration: 0.35
                            )
                            CubicKeyframe(.zero, duration: 0.35)
                        }
                        
                        KeyframeTrack(\.scale) {
                            LinearKeyframe(0.01, duration: delay)
                            CubicKeyframe(1.1, duration: 0.35)
                            CubicKeyframe(1.0, duration: 0.2)
                        }
                        
                        KeyframeTrack(\.opacity) {
                            LinearKeyframe(1, duration: delay + 0.6)
                        }
                    }
                }
            }
        }
        .padding(.top, 24)
    }
}

// MARK: - Actions
private extension AbsorptionSearchBar {
    
    func startSearch() {
        withAnimation {
            phase = .absorbing
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            squashSearchBar()
        }
    }
    
    func squashSearchBar() {
        withAnimation(.easeIn(duration: 0.12)) {
            searchBarScale = .init(width: 1.15, height: 0.85)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                searchBarScale = .init(width: 1, height: 1)
            }
        }
    }
    
    func cancelSearch() {
        withAnimation {
            phase = .pouringBack
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            phase = .idle
            searchText = ""
        }
    }
}

// MARK: - Result Row
struct ResultRow: View {
    let item: SearchResult
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.icon)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.15))
                .clipShape(Circle())
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.headline)
                Text(item.subtitle).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        .padding(.horizontal)
        .frame(height: 60)
    }
}

// MARK: - Preferences
struct SearchBarFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct ItemFrameKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

// MARK: - Preview
#Preview {
    AbsorptionSearchBar()
}

