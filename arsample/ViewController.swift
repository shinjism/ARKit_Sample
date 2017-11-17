//
//  ViewController.swift
//  arsample
//
//  Created by Shinji Hayai on 2017/11/16.
//  Copyright © 2017年 Shinji Hayai. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("feature/test1")
        
        // シーンを生成してARSCNViewにセット
        sceneView.scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.session.delegate = self
        sceneView.delegate = self

        // セッションのコンフィグレーションを生成
        let configuration = ARWorldTrackingConfiguration()
        configuration.providesAudioData = false
        configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal

        // セッション開始
        sceneView.session.run(configuration)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { fatalError() }
        
        // 平面ジオメトリを作成
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                height: CGFloat(planeAnchor.extent.z))
        geometry.materials.first?.diffuse.contents = UIColor.yellow
        
        // 平面ジオメトリを持つノードを作成
        let planeNode = SCNNode(geometry: geometry)
        
        // 平面ジオメトリを持つノードをx軸まわりに90度回転
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        
        DispatchQueue.main.async(execute: {
            // 検出したアンカーに対応するノードに子ノードとして持たせる
            node.addChildNode(planeNode)
        })
    }
}
