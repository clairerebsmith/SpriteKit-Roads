//
//  GameViewController.swift
//  Roads
//
//  Created by Claire Smith Co on 21/12/2021.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    //variables
    
    var scene: SKScene!
    
    // functions
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {

                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            view.preferredFramesPerSecond = 120
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    @IBAction func exitTapped(_ sender: Any) {
        let possibleTimers = ["timer", "gameTimer"]
        let invalidate = NSSelectorFromString("invalidate")
        
        for possible in possibleTimers {
            let sel = NSSelectorFromString(possible)
            if scene.responds(to: sel) {
                let maybeTimer = scene.perform(sel)
                
                if maybeTimer?.takeUnretainedValue().responds(to: invalidate) ?? false {
                    maybeTimer?.takeRetainedValue().perform(invalidate)
                }
            }
        }
        
        dismiss(animated: true)
    }
}
