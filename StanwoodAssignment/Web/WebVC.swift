//
//  WebVC.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    public var url = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        webView.navigationDelegate = self
        if let url =  URL(string: url){
            webView.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ActivityIndicatorManager.endActivity()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ActivityIndicatorManager.startActivity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
