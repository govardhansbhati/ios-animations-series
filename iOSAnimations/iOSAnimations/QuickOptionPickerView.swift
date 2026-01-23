import SwiftUI

struct QuickOptionPickerView: View {
    @State private var selection: PrivacyOption = .private
    @State private var isExpanded: Bool = false
    @Namespace private var animation
    
    // Background color for the demo
    private let backgroundColor = Color(uiColor: .systemGroupedBackground)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // The Picker
                Group {
                    if isExpanded {
                        expandedView
                    } else {
                        collapsedView
                    }
                }
                // Animate layout changes
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: isExpanded)
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selection)
                
                Spacer()
                
                // Helper text
                Text("Tap the capsule to toggle options")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 50)
            }
        }
        .navigationTitle("Quick Option Picker")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Collapsed View
    var collapsedView: some View {
        Button {
            isExpanded = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: selection.iconName)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(selection.color)
                    .matchedGeometryEffect(id: "icon-\(selection.id)", in: animation)
                
                Text(selection.rawValue)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary.opacity(0.8))
                    .matchedGeometryEffect(id: "text-\(selection.id)", in: animation)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background {
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .matchedGeometryEffect(id: "background", in: animation)
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Expanded View
    var expandedView: some View {
        HStack(spacing: 0) {
            ForEach(PrivacyOption.allCases) { option in
                Button {
                    selection = option
                    isExpanded = false
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: option.iconName)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(option.color)
                            .matchedGeometryEffect(id: "icon-\(option.id)", in: animation)
                        
                        Text(option.rawValue)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primary)
                            .matchedGeometryEffect(id: "text-\(option.id)", in: animation)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                
                // Divider between options
                if option != PrivacyOption.allCases.last {
                    Divider()
                        .frame(height: 24)
                }
            }
        }
        .background {
            Capsule()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                .matchedGeometryEffect(id: "background", in: animation)
        }
    }
}

// MARK: - Models
enum PrivacyOption: String, CaseIterable, Identifiable {
    case `private` = "Private"
    case publicOption = "Public"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .private: return "lock.fill"
        case .publicOption: return "globe"
        }
    }
    
    var color: Color {
        switch self {
        case .private: return .gray
        case .publicOption: return .black
        }
    }
}

#Preview {
    NavigationStack {
        QuickOptionPickerView()
    }
}
