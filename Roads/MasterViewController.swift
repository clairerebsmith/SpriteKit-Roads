//
//  MasterViewController.swift
//  Roads
//
//  Created by Claire Smith Co on 21/12/2021.
//

import UIKit
import WebKit

class MasterViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!

    var header = ""
    var footer = ""
    var chapter = "toc.html"
    var step: Int?

    var firstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartTapped))

        if let step = step {
            title = "Step \(step)"
        } else {
            title = "Contents"
        }

        webView.navigationDelegate = self

        let headerPath = Bundle.main.url(forResource: "header.html", withExtension: nil)!
        let footerPath = Bundle.main.url(forResource: "footer.html", withExtension: nil)!

        header = (try? String(contentsOf: headerPath)) ?? ""
        footer = (try? String(contentsOf: footerPath)) ?? ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if firstLoad {
            // start our own loading immediately so there's no delay
            webView.loadChapter(chapter, header, footer)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if firstLoad {
            firstLoad = false
            // only load the matching source code once our transition has finished
            loadDetailChapter(chapter)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)

            guard let filename = navigationAction.request.url?.absoluteURL.lastPathComponent else {
                fatalError("Could not read filename from request.")
            }

            if filename == "toc.html" {
                navigationController?.popToRootViewController(animated: true)
            } else {
                guard let newVC = storyboard?.instantiateViewController(withIdentifier: "Master") as? MasterViewController else {
                    fatalError("Failed to load master view controller.")
                }

                newVC.chapter = filename
                newVC.step = (step ?? 0) + 1
                navigationController?.pushViewController(newVC, animated: true)
            }

//            loadDetailChapter(filename)
        } else {
            decisionHandler(.allow)
        }
    }

    func loadDetailChapter(_ filename: String) {
        guard let detailNavigation = splitViewController?.viewControllers[1] as? UINavigationController else {
            fatalError("Unable to communicate with detail view controller.")
        }

        guard let detailVC = detailNavigation.topViewController as? DetailViewController else {
            fatalError("Unable to communicate with detail view controller.")
        }

        if filename == "toc.html" {
            detailVC.chapter = "source-code.html"
        } else {
            let swiftFilename = filename.replacingOccurrences(of: ".html", with: ".swift.html")
            let noTildes = swiftFilename.replacingOccurrences(of: "~", with: "_")
            let noDashes = noTildes.replacingOccurrences(of: "-", with: "_")
            let gameSceneName = "GameScene_\(noDashes)"
            detailVC.chapter = gameSceneName
        }
    }

    @objc func restartTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
