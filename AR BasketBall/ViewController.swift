//
//  ViewController.swift
//  AR BasketBall
//
//  Created by Haitham Abdel Wahab on 2/25/19.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var currentNode : SCNNode!
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addHoopBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
       
        registerGestureRecognizer()
    }
    
    func registerGestureRecognizer() {
        // action howa el action elly hyet3emel bemogarrad mtelmes elshasha
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tap)
    }
    // handleTap : elfunc ellybetem ested3a2ha lma ted3'at 3lscreen

    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        //محتاجين ننشئ كورة سلة
        //scene view to be accessed elly ne3meloh lelwosool
        
        //access the poin of view of that scene view ... the center point
        guard let sceneView = gestureRecognizer.view as? ARSCNView else {
            return
        }
        guard let centerPoint = sceneView.pointOfView else {
            return
        }

        //transform matrix
        //       understanding of matrix :
//       transformMatrix =
//            [  23,54,76,343
//               54,232,23,43
//               76,233,65,54
//               654,87,77,99] contains // to rows and colums to access :transformMatrix (4,2) = 87
//
        //the oriantation
        //the location of the camera
        //we need the oriantation and location to determine the position of the camera and it's at this point in which we want the ball to be placed

        
        
        let cameraTransform = centerPoint.transform
        let cameraLocation = SCNVector3(x:cameraTransform.m41,y:cameraTransform.m42,z:cameraTransform.m43)
        let cameraOriantation =
            SCNVector3(x: -cameraTransform.m31 ,y: -cameraTransform.m32, z: -cameraTransform.m33)
       
        //(x1 + x2), (y1 + y2), (z1 + z2)
        let cameraPosition = SCNVector3Make(cameraLocation.x + cameraOriantation.x, cameraLocation.y+cameraOriantation.y, cameraLocation.z + cameraOriantation.z)
      
        //create basketball
        
        let ball = SCNSphere(radius: 0.15)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "basketballSkin.png")
        ball.materials = [material]
        
        let ballNode = SCNNode(geometry: ball)
        ballNode.position = cameraPosition
        
        // Adding a PhysicsBody for ball
        let physicsShape = SCNPhysicsShape(node: ballNode, options: nil)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        
        ballNode.physicsBody = physicsBody
        let forceVector:Float = 6
        ballNode.physicsBody?.applyForce(SCNVector3(x: cameraOriantation.x * forceVector,y: cameraOriantation.y * forceVector , z: cameraOriantation.z * forceVector), asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(ballNode)
        
    }
    func addBackboard() {
        guard let backboardScene = SCNScene(named: "art.scnassets/hoop.scn") else {
            return
        }
        //recursively خلناها فولس عشان منحددش مكان الفروع اللي جواها اللي هما rim و RimHolder_001
        // 
        guard let backboardNode = backboardScene.rootNode.childNode(withName: "backboard", recursively: false) else {
            return
        }
        // SCNVector3 ده نستخدمه لما نستخدم كانات ثلاثسة الابعاد في مساحة ثلاثية الابعاد من اجل ضبط موضع الكائن في السبيس
        // x :center in phone y: above to phone z: in fron of phone
        backboardNode.position = SCNVector3(x: 0,y: 0.5, z: -3)
        // to add backboardNode to the scene
     
        // Adding a PhysicsBody for ball

        let physicsShape = SCNPhysicsShape(node: backboardNode, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        let physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        
        backboardNode.physicsBody = physicsBody
       // let forceVector:Float = 6
       // ballNode.physicsBody?.applyForce(SCNVector3(x: cameraOriantation.x * forceVector,y: cameraOriantation.y * forceVector , z: cameraOriantation.z * forceVector), asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(backboardNode)
        currentNode = backboardNode
    }
    //  Creating my First Action : bet5ally elboard btegy yemeen w shemaal
    func horizontalAction(node: SCNNode){
        //da elly hat2om beeh el coora -1 is mean 1 meter to the left .. every 3 second
        let leftAction = SCNAction.move(by: SCNVector3(x: -1,y: 0,z: 0), duration: 3)

        //da elly hat2om beeh el coora 1 is mean 1 meter to the right .. every 3 second
        let rightAction = SCNAction.move(by: SCNVector3(x: 1,y: 0,z: 0), duration: 3)
        let actionSequence = SCNAction.sequence([leftAction, rightAction])
        node.runAction(SCNAction.repeat(actionSequence, count: 4))
        
        
    }
  //  Creating my Second Action : bta3 el coora ye5alleha tenzel we tetnattat 7ettet nattta heeeeh :D
    func roundAction(node: SCNNode) {
        let upLeft = SCNAction.move(by: SCNVector3(x: 1,y: 1,z: 0), duration: 2)
        let downRight = SCNAction.move(by: SCNVector3(x: 1,y: -1,z: 0), duration: 2)
        let downLeft = SCNAction.move(by: SCNVector3(x: -1,y: -1,z: 0), duration: 2)
        let upRight = SCNAction.move(by: SCNVector3(x: -1,y: 1,z: 0), duration: 2)

        let actionSequence = SCNAction.sequence([upLeft,downRight, downLeft, upRight])
        
        node.runAction(SCNAction.repeat(actionSequence, count: 2))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @IBAction func starrtRoundAction(_ sender: Any) {
        roundAction(node: currentNode)
    }
    
    @IBAction func stopAllActions(_ sender: Any) {
        currentNode.removeAllActions()
    }
    
    @IBAction func startHorizontalAction(_ sender: Any) {
        horizontalAction(node: currentNode)
    }
    
    @IBAction func addHoop(_ sender: Any) {
        addBackboard()
        addHoopBtn.isHidden = true
    }
    
}
