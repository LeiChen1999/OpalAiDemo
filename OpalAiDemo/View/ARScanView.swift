//
//  ARScanView.swift
//  OpalAiDemo
//
//  Created by Lei Chen on 5/15/23.
//

import Foundation
import SwiftUI
import SceneKit

struct ARScanView: View {
    @ObservedObject var sceneKitManager = SceneKitManager()
    var body: some View {
        SceneKitView(sceneKitManager: SceneKitManager())
    }
}

class SceneKitManager: ObservableObject {
    let scene = SCNScene()
    var modelNode: SCNNode!
    var cameraNode: SCNNode!
    @Published var isRotating: Bool = true

    init() {
        // Add Camera
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        scene.rootNode.addChildNode(cameraNode)

        // Load Model
        let modelScene = SCNScene(named: "2.usdz")!
        modelNode = modelScene.rootNode.childNodes[0]
        scene.rootNode.addChildNode(modelNode)

        // Calculate model size
        let (min, max) = modelNode.boundingBox
        let modelSize = SCNVector3Make(max.x - min.x, max.y - min.y, max.z - min.z)

        // Modify camera position based on model size
        let cameraDistance = modelSize.z * 1 // Adjust this multiplier as needed
        cameraNode.position = SCNVector3(x: 0, y: 0, z: Float(cameraDistance) + 30)
        
        // set Light
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = .omni
        omniLightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(omniLightNode)

        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)

        // Start Rotating Model
        startRotatingModel()
    }

    func startRotatingModel() {
        // Create a rotation action
        let rotationAction = SCNAction.rotate(by: CGFloat.pi, around: SCNVector3(0, 1, 0), duration: 5)

        // Create a sequence of actions
        let sequence = SCNAction.sequence([rotationAction, SCNAction.wait(duration: 2)])

        // Run the sequence in loop
        modelNode.runAction(SCNAction.repeatForever(sequence))
    }
    
    func stopRotatingModel() {
        modelNode.removeAllActions()
    }
}

struct SceneKitView: UIViewRepresentable {
    @ObservedObject var sceneKitManager: SceneKitManager

    func makeUIView(context: Context) -> CustomSCNView {
        let scnView = CustomSCNView()
        scnView.scene = sceneKitManager.scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.white
        scnView.sceneKitManager = sceneKitManager

        return scnView
    }

    func updateUIView(_ scnView: CustomSCNView, context: Context) {
        scnView.sceneKitManager = sceneKitManager
    }
}

class CustomSCNView: SCNView {
    var sceneKitManager: SceneKitManager? = nil
    var stopTiem = 2.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneKitManager?.stopRotatingModel()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Keep model stationary while user is dragging
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Resume rotating after a delay when user stops dragging
        DispatchQueue.main.asyncAfter(deadline: .now() + stopTiem) {
            self.sceneKitManager?.startRotatingModel()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Resume rotating after a delay when touch is cancelled
        DispatchQueue.main.asyncAfter(deadline: .now() + stopTiem) {
            self.sceneKitManager?.startRotatingModel()
        }
    }
}
