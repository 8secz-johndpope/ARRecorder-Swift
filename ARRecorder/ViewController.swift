//
//  ViewController.swift
//  ARRecorder
//
//  Created by wxh on 2019/1/18.
//  Copyright © 2019 realibox. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController {

    var session: ARSession {
        return self.arView.session
    }
    lazy var arView: ARSCNView = {
        let view = ARSCNView()
        view.delegate = self
        return view
    }()
    
    lazy var recorder: ARRecorder = {
        let recorder = ARRecorder()
        return recorder
    }()

    lazy var startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .brown
        button.setTitle("start", for: .normal)
        button.setTitle("stop", for: .selected)
        button.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.arView)
        self.view.addSubview(self.startButton)
        
        self.startButton.isUserInteractionEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.arView.frame = self.view.bounds

        self.startButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        self.startButton.center = self.view.center
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        self.session.run(config, options: [ARSession.RunOptions.resetTracking, ARSession.RunOptions.removeExistingAnchors])
    }
    
    let dispatchQueue = DispatchQueue(label: "fdasf")
    
    @objc func setupButtonAction() {
        
        
        self.startButton.isUserInteractionEnabled = true
        self.startButton.backgroundColor = .red
    }
    @objc func startButtonAction() {
        if self.startButton.isSelected {
            self.recorder.stopRecording { (url) in
                print(url)
            }
            self.startButton.isSelected = false
            self.startButton.backgroundColor = .red
        } else {
            self.recorder.startRecording(self.arView)
            self.startButton.isSelected = true
            self.startButton.backgroundColor = .green
        }
    }

}
extension ViewController: ARSCNViewDelegate
{
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let box = SCNNode()
        box.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        node.addChildNode(box)
    }
}

