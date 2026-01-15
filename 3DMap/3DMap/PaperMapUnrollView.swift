import SwiftUI
import SceneKit
import Foundation

struct PaperMapUnrollView: UIViewRepresentable {
    @Binding var isUnrolled: Bool
    var mapImage: UIImage?

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.antialiasingMode = .multisampling4X
        scnView.autoenablesDefaultLighting = false // DISABLE DEFAULT
        
        let scene = PaperMapScene(isUnrolled: isUnrolled, mapImage: mapImage)
        scnView.scene = scene
        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Trigger animation if state changed
        if let scene = uiView.scene as? PaperMapScene {
            scene.isUnrolled = isUnrolled
            scene.updateState(animated: true)
        }
    }
}

class PaperMapScene: SCNScene {
    var isUnrolled: Bool
    let topScrollNode = SCNNode()
    let bottomScrollNode = SCNNode()
    let paperNode = SCNNode()
    
    let maxMapHeight: CGFloat = 1.6
    let maxRadius: CGFloat = 0.2
    let minRadius: CGFloat = 0.05
    
    init(isUnrolled: Bool, mapImage: UIImage?) {
        self.isUnrolled = isUnrolled
        super.init()
        setupScene(mapImage: mapImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene(mapImage: UIImage?) {
        background.contents = UIColor.clear // Transparent integration
        
        // CAMERA
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // Move camera closer (from 3.5 to 2.4) to fill the screen with the map height (1.6)
        cameraNode.position = SCNVector3(0, 0, 2.4)
        rootNode.addChildNode(cameraNode)
        
        // LIGHTING (MATTE SETUP)
        // 1. strong Ambient for flatness
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 1200 // Bright base
        rootNode.addChildNode(ambientLight)
        
        // 2. Soft Directional from Top-Left for scroll depth (no direct reflection)
        let directionalNode = SCNNode()
        directionalNode.light = SCNLight()
        directionalNode.light?.type = .directional
        directionalNode.light?.intensity = 400
        directionalNode.eulerAngles = SCNVector3(-(Float.pi/4), -(Float.pi/4), 0)
        rootNode.addChildNode(directionalNode)
        
        // GEOMETRY SETUP
        
        // 1. Image Aspect calculation
        
        // 2. Paper Plane

        let plane = SCNPlane(width: 1.0, height: maxMapHeight)
        plane.widthSegmentCount = 10
        plane.heightSegmentCount = 10
        plane.firstMaterial?.diffuse.contents = mapImage ?? UIColor.white
        plane.firstMaterial?.isDoubleSided = true
        plane.firstMaterial?.lightingModel = .physicallyBased
        plane.firstMaterial?.roughness.contents = 1.0 // Fully Matte (No shine)
        plane.firstMaterial?.metalness.contents = 0.0
        
        paperNode.geometry = plane
        paperNode.name = "paper"
        rootNode.addChildNode(paperNode)
        
        // 3. Scrolls (Top and Bottom)

        let scrollGeo = SCNCylinder(radius: maxRadius, height: 1.05) // Slightly wider than paper
        scrollGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.9, green: 0.85, blue: 0.7, alpha: 1.0) // Parchment color
        scrollGeo.firstMaterial?.lightingModel = .physicallyBased
        scrollGeo.firstMaterial?.roughness.contents = 0.6 // Slightly smoother than paper
        
        topScrollNode.geometry = scrollGeo
        topScrollNode.eulerAngles.z = Float.pi / 2 // Horizontal
        
        // Clone for bottom
        bottomScrollNode.geometry = scrollGeo.copy() as? SCNCylinder
        bottomScrollNode.eulerAngles.z = Float.pi / 2
        
        rootNode.addChildNode(topScrollNode)
        rootNode.addChildNode(bottomScrollNode)
        
        // Initial State
        updateState(animated: false)
    }
    
    func updateState(animated: Bool) {
        // We want to animate from Current State to Target State.

        
        let duration = animated ? 1.2 : 0.0
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        if isUnrolled {
            // OPEN STATE
            paperNode.scale = SCNVector3(1, 1, 1)

            
            // Scrolls move to edges
            let yOffset = maxMapHeight / 2.0
            topScrollNode.position.y = Float(yOffset)
            bottomScrollNode.position.y = Float(-yOffset)
            
            // Scrolls shrink
            (topScrollNode.geometry as? SCNCylinder)?.radius = minRadius
            (bottomScrollNode.geometry as? SCNCylinder)?.radius = minRadius
            
            // Hanger Adjustment (If needed, e.g. scale up?) - logic keeps it attached to topScroll
             
            // Rotate scrolls (visual flair)
            topScrollNode.eulerAngles.y = -(Float.pi * 2)
            bottomScrollNode.eulerAngles.y = Float.pi * 2
            
        } else {
            // CLOSED STATE
            paperNode.scale = SCNVector3(1, 0.01, 1)

            
            // Scrolls meet in middle
            topScrollNode.position.y = Float(maxRadius) - 0.05 // Slight adjustments
            bottomScrollNode.position.y = Float(-maxRadius) + 0.05
            
            // Scrolls grow
            (topScrollNode.geometry as? SCNCylinder)?.radius = maxRadius
            (bottomScrollNode.geometry as? SCNCylinder)?.radius = maxRadius
            
            // Reset Rotation
            topScrollNode.eulerAngles.y = 0
            bottomScrollNode.eulerAngles.y = 0
        }
        
        SCNTransaction.commit()
    }
}

