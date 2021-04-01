//
//  WebViewController.swift
//  Browser
//
//  Created by Sergey Sorokin on 30.03.2021.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private var mainView: WebView {
        return view as! WebView
    }
    
    weak var historyDelegate: HistoryDelegate!
    
    var titlesArray = [String]()
    
    override func loadView() {
        view = WebView()
        
        mainView.webView.uiDelegate = self
        mainView.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myUrl = URL(string: "https://www.google.ru/")
        let myRequest = URLRequest(url: myUrl!)
        mainView.webView.load(myRequest)
        
        mainView.backButton.addTarget(self, action: #selector(customGoBack), for: .touchUpInside)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let title = webView.title {
            titlesArray.append(title)
            updateTitle()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                if let url = navigationAction.request.url {
                    mainView.webView.load(URLRequest(url: url))
                    historyDelegate.addPage(url: url.absoluteString)
                }
            }
        decisionHandler(.allow)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func customGoBack(sender: UIButton) {
        if mainView.webView.canGoBack {
            print("Can go back")
            mainView.webView.goBack()
            titlesArray.removeLast()
            updateTitle()
        } else {
            print("Can't go back")
        }
    }
    
    func updateTitle() {
        mainView.adressField.text = titlesArray.last
    }
}
