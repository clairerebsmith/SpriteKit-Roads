//
//  WKWebView+LoadChapter.swift
//  Roads
//
//  Created by Claire Smith Co on 21/12/2021.
//
import Foundation
import WebKit

extension WKWebView {
    func loadChapter(_ name: String, _ header: String, _ footer: String) {
        guard let path = Bundle.main.url(forResource: name, withExtension: nil) else {
            fatalError("Attempted to load an unknown resource: \(name)")
        }

        let body = try! String(contentsOf: path)
        let html = "\(header)\(body)\(footer)"

        loadHTMLString(html, baseURL: Bundle.main.resourceURL)
    }
}
