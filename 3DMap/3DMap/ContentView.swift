
import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isMapVisible = false // Controls Navigation
    @State private var mapTexture: UIImage? = nil
    @State private var isGeneratingMap = false
    
    var body: some View {
        ZStack {
            // MAIN CONTENT
            NavigationView {
                List(mockPlaces) { place in
                    HStack(spacing: 15) {
                        Image(systemName: place.imageName)
                            .font(.system(size: 30))
                            .frame(width: 50, height: 50)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                            Text(place.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .navigationTitle("City Guide")
                .background(
                    NavigationLink(
                        destination: MapDetailView(mapImage: mapTexture),
                        isActive: $isMapVisible,
                        label: { EmptyView() }
                    )
                )
                // Floating Button as Overlay within NavigationView
                .overlay(
                    VStack {
                        Spacer()
                        Button(action: {
                            isGeneratingMap = true
                            
                            // Generate Snapshot
                            let region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 18.5204, longitude: 73.8567), // Pune
                                span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                            )
                            
                            MapSnapshotGenerator.generateSnapshot(region: region, size: CGSize(width: UIScreen.main.bounds.width, height: 600)) { image in
                                self.mapTexture = image
                                self.isGeneratingMap = false
                                self.isMapVisible = true
                            }
                        }) {
                            HStack {
                                if isGeneratingMap {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .padding(.trailing, 5)
                                }
                                Text(isGeneratingMap ? "Loading..." : "Open Map")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                        }
                        .padding(.bottom, 20)
                        .disabled(isGeneratingMap)
                    }
                )
            }
        }
    }
}
