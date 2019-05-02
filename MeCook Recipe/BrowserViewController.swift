//
//  BrowserViewController.swift
//  MeCook Recipe
//
//  Created by Allan Shivji on 4/9/19.
//  Copyright © 2019 Allan Shivji. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var forwardBtn: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CheckInternet.Connection() {
            checkInternetConnection()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        webView.load(URLRequest(url: URL(string: "https://www.google.com")!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Loaded...")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
 
    @IBAction func backButton(_ sender: Any) {
        
        if !CheckInternet.Connection() {
            checkInternetConnection()
        } else {
            if webView.canGoBack {
                webView.goBack()
            }
        }
    }
    
    @IBAction func forwardButton(_ sender: Any) {
        
        if !CheckInternet.Connection() {
            checkInternetConnection()
        } else {
            if webView.canGoForward {
                webView.goForward()
            }
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        if !CheckInternet.Connection() {
            checkInternetConnection()
        } else {
            webView.reload()
        }
    }
    
    func checkInternetConnection () {
        
        let alert = UIAlertController(title: "Cellular Data is Turned Off", message: "Turn on cellular data or use Wi-Fi to access data.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
