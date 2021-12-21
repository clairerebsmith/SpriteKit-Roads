//
//  SplitViewController.swift
//  Roads
//
//  Created by Claire Smith Co on 21/12/2021.
//

import UIKit

class SplitViewController: UISplitViewController {
    var shouldBeObviousWarningShown = false

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if shouldBeObviousWarningShown == false {
            let copyrightAlert = UIAlertController(title: "Important!", message: "This project has been made with the help of the book Diving into SpriteKit", preferredStyle: .alert)
            copyrightAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(copyrightAlert, animated: true)
            shouldBeObviousWarningShown = true
        }
    }
}
