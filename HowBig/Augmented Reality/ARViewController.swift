//
//  ARViewController.swift
//  HowBig
//
//  Created by Anton on 07.07.2022.
//

import UIKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    var dogBreed: String?
    var dogHeight: Float?
    var dogsArray = [Dog]() {
        didSet {
            DispatchQueue.main.async {
                let dogSize = self.dogsArray.filter{$0.name == self.dogBreed}
                self.dogHeight = Float(dogSize[0].height.metric.components(separatedBy: " ").first!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Networking().getDogs(handler: { dogs in self.dogsArray = dogs })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.gesture(recogniser:)))
        sceneView.addGestureRecognizer(recognizer)
    }
    
    @objc func gesture(recogniser: UIGestureRecognizer) {
        let tapLocation = recogniser.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let result = hitTestResult.first?.worldTransform.translation,
              let scene = SCNScene.init(named: "art.scnassets/wolf.dae"),
              let dogNode = scene.rootNode.childNode(withName: "wolf", recursively: false)
              else {return}
        
        let scaleX = dogHeight!/34
        print(dogHeight)
        dogNode.position = SCNVector3(result.x, result.y, result.z)
        dogNode.scale = SCNVector3(x: scaleX, y: scaleX, z: scaleX)
        sceneView.scene.rootNode.addChildNode(dogNode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension float4x4 {
    var translation: float3 {
        let column = self.columns.3
        return float3(column.x, column.y, column.z)
    }
}
