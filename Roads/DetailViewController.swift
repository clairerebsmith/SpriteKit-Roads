//
//  DetailViewController.swift
//  Roads
//
//  Created by Claire Smith Co on 21/12/2021.
//

import SpriteKit
import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var webView: WKWebView!

    var header = ""
    var footer = ""

    var chapter: String = "" {
        didSet {
            webView.loadChapter(chapter, header, footer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Source Code"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(runChapter))

        let headerPath = Bundle.main.url(forResource: "header.html", withExtension: nil)!
        let footerPath = Bundle.main.url(forResource: "footer.html", withExtension: nil)!
        
        header = (try? String(contentsOf: headerPath)) ?? ""
        footer = (try? String(contentsOf: footerPath)) ?? ""
        
        webView.loadChapter("source-code.html", header, footer)
    }

    @objc func runChapter() {
        let filename = chapter.replacingOccurrences(of: ".swift.html", with: "")
        let gameClass = NSClassFromString("ProjectSourceCode.\(filename)")

        guard let sceneClass = gameClass as? SKScene.Type else {
            fatalError("Could not instantiate class: \(filename)")
        }
        
        let scene = sceneClass.init()

        guard let game = storyboard?.instantiateViewController(withIdentifier: "Game") as? GameViewController else {
            fatalError("Could not launch game view controller")
        }

        scene.size = CGSize(width: 1024, height: 768)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.physicsWorld.gravity = .zero

        game.scene = scene
        present(game, animated: true)
    }
}
