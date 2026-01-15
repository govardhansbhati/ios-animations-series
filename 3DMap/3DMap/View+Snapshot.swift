import SwiftUI

extension View {
    @MainActor
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: 600)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// A dedicated view wrapper to capture the texture efficiently
import MapKit

class MapSnapshotGenerator {
    static func generateSnapshot(region: MKCoordinateRegion, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = size
        options.scale = UIScreen.main.scale
        options.mapType = .hybrid // Use Hybrid for guaranteed visuals
        options.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                print("Snapshot error: \(error?.localizedDescription ?? "Unknown")")
                completion(nil)
                return
            }
            
            let image = snapshot.image
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            let context = UIGraphicsGetCurrentContext()!
            
            // 1. Draw Map
            image.draw(at: .zero)
            
            // 2. Apply Sepia Tint Overlay
            context.saveGState()
            context.setBlendMode(.multiply) // Multiply blend for tint
            // Brown/Sepia color
            UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 0.6).setFill() 
            context.fill(CGRect(origin: .zero, size: image.size))
            context.restoreGState()
            
            // 3. Draw Pin
            let pinImage = UIImage(systemName: "mappin.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            let point = snapshot.point(for: region.center)
            
            if let pin = pinImage {
                let pinCenter = CGPoint(x: point.x - 15, y: point.y - 30)
                pin.draw(in: CGRect(origin: pinCenter, size: CGSize(width: 30, height: 30)))
            }
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completion(finalImage)
        }
    }
}

