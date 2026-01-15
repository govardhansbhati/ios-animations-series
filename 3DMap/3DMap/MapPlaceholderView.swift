import SwiftUI
import MapKit

struct MapPlaceholderView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 18.5204, longitude: 73.8567), // Pune
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )
    
    var body: some View {
        ZStack {
            // Using actual Map for better realism, updated to iOS 17+ MapContentBuilder API
            Map(initialPosition: .region(region)) {
                // Optional: a subtle marker near the center for realism without interaction
                Marker("Market St", coordinate: region.center)
            }
            .disabled(true) // Disable interaction for the fold demo to prevent gestures stealing
            .overlay(
                Color.black.opacity(0.1) // Subtle tint
            )
            
            // "Where to?" Pin
            VStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                    .shadow(radius: 4)
                
                Text("Market St")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .shadow(radius: 2)
            }
            .offset(y: -20)
            
            // Add a visual top/bottom border to simulation map edges
            Rectangle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)

        }
    }
}

#Preview {
    MapPlaceholderView()
}
