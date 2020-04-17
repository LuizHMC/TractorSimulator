//
//  GameViewController.swift
//  Tractor Simulator
//
//  Created by Luiz Henrique Monteiro de Carvalho on 15/04/20.
//  Copyright © 2020 Luiz Henrique Monteiro de Carvalho. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import AVFoundation

class GameViewController: UIViewController {
    
    let scene = SCNScene(named: "art.scnassets/tractor.scn")!
    var audioPlayer = AVAudioPlayer()
    
    let musics:[String] = ["dueloffates","acrossthestars","imperialmarch","starwarsmaintheme","battleofheroes","astronomia","rickastley","nyancat","vitas7element","roundabout","concerningofthehobbits","manymeetings","khazaddum","thebreakingfellowship","ridersofrohan"]
    
    var rotationdrift:Int = 0
    
    lazy var sauroneye = scene.rootNode.childNode(withName: "sauroneye", recursively: true)!
    lazy var tractor = scene.rootNode.childNode(withName: "cabine", recursively: true)!
    
    lazy var lightsaber = scene.rootNode.childNode(withName: "lightsaber", recursively: true)!
    
    lazy var rodastratortras = scene.rootNode.childNode(withName: "rodastratortras", recursively: true)!
    
    lazy var rodastratorfrente = scene.rootNode.childNode(withName: "rodasfrente", recursively: true)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        var sound = Bundle.main.path(forResource: musics[Int.random(in: 0 ... (musics.count)-1)], ofType: "mp3")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch {
            print(error)
        }
        audioPlayer.numberOfLoops = -1
        
                
        let widthview = self.view.frame.size.width
        let heightview = self.view.frame.size.height

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        

        let scnView = self.view as! SCNView
        
        scnView.scene = scene
        
        scnView.allowsCameraControl = true
        
        //titulo app
        let titleapp = UILabel(frame: CGRect(x: widthview/4, y: heightview/18, width: 300, height: 50))
        titleapp.text = "Tractor Simulator"
        titleapp.font = UIFont (name: "Helvetica", size: 30)
        self.view.addSubview(titleapp)
        
        
        //botoes
        let driftbutton = UIButton(frame: CGRect(x: (widthview)/10, y: (heightview)-100, width: 75, height: 75))
        driftbutton.addTarget(self, action: #selector(driftButtonAction), for: .touchUpInside)
        driftbutton.setImage(UIImage(named: "driftbutton.jpg"), for: .normal)
        self.view.addSubview(driftbutton)
        
        let stopbutton = UIButton(frame: CGRect(x: (widthview)-110, y: (heightview)-100, width: 75, height: 75))
        stopbutton.addTarget(self, action: #selector(stopButtonAction), for: .touchUpInside)
        stopbutton.setImage(UIImage(named: "stopbutton.jpg"), for: .normal)
        self.view.addSubview(stopbutton)
        
        let playmusicbutton = UIButton(frame: CGRect(x: (widthview)/3-10 , y: (heightview)-100, width: 75, height: 75))
        playmusicbutton.addTarget(self, action: #selector(playMusicAction), for: .touchUpInside)
        playmusicbutton.setImage(UIImage(named: "randomplayerbutton.jpg"), for: .normal)
        self.view.addSubview(playmusicbutton)
        
        let jumpbutton = UIButton(frame: CGRect(x: (widthview)/2+10, y: (heightview)-100, width: 75, height: 75))
        jumpbutton.addTarget(self, action: #selector(jumpAction), for: .touchUpInside)
        jumpbutton.setImage(UIImage(named: "jump.jpg"), for: .normal)
        self.view.addSubview(jumpbutton)
        prepareMusic()
        
        
    }
    
    func prepareMusic(){
        audioPlayer.play()
    }
    
    @objc func jumpAction(sender: UIButton!) {
        JumpAll()
    }

    func JumpAll() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            self.tractor.position.y -= 3
            SCNTransaction.commit()
        }
        self.tractor.position.y += 3
        SCNTransaction.commit()
    }
    
    @objc func driftButtonAction(sender: UIButton!) {
        if rotationdrift <= 4 {
            rotationdrift += 1
            print("driftbutton")
        }
        sauroneye.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: CGFloat(rotationdrift), y: 0, z: 0, duration: 1)))
        rodastratortras.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(rotationdrift), z: 0, duration: 1)))
        rodastratorfrente.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(rotationdrift), z: 0, duration: 1)))
        lightsaber.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(rotationdrift), z: CGFloat(rotationdrift), duration: 1)))
        print(rotationdrift)
        print(sauroneye.position.y)
    }
    
    @objc func stopButtonAction(sender: UIButton!) {
        rotationdrift = 0
        lightsaber.removeAllActions()
        sauroneye.removeAllActions()
        rodastratortras.removeAllActions()
        rodastratorfrente.removeAllActions()
        print(rotationdrift)

    }
    
    @objc func playMusicAction(sender: UIButton!) {
        var sound = Bundle.main.path(forResource: musics[Int.random(in: 0 ... (musics.count)-1)], ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch {
            print(error)
        }
        audioPlayer.play()
        print("Play music Button tapped")
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
