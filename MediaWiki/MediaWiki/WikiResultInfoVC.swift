//
//  WikiResultInfoVC.swift
//  MediaWiki
//
//  Created by Mac Mini on 29/09/18.
//

import UIKit
import WebKit

class WikiResultInfoVC: UIViewController, WKNavigationDelegate {
    @IBOutlet var textLabel: UILabel!

    var webView: WKWebView!
    var urlString: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        let url = urlString.replacingOccurrences(of: " ", with: "_")
        urlString = WikiPediaLink + url
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}
