//
//  WebViewController.swift
//  Browser
//
//  Created by Sergey Sorokin on 30.03.2021.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    @objc private var mainView: WebView {
        return view as! WebView
    }
    
    weak var historyDelegate: HistoryDelegate!
    
    private var observation: NSKeyValueObservation?
    
    override func loadView() {
        view = WebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.webView.uiDelegate = self
        mainView.webView.navigationDelegate = self
        mainView.adressField.delegate = self
        
        observation = observe(\.mainView.webView.url, options: [.old, .new]) { (object, change) in
            self.mainView.adressField.text = self.mainView.webView.url?.absoluteString
        }
        
        goToFirstPage()
        
        mainView.adressField.addTarget(self, action: #selector(goToPage), for: .editingDidEnd)
        
        mainView.backButton.addTarget(self, action: #selector(customGoBack), for: .touchUpInside)
        
        mainView.forwardButton.addTarget(self, action: #selector(customGoForward), for: .touchUpInside)
        
        
    }
    
    func goToFirstPage() {
        
        let myUrl = URL(string: "https://www.google.ru/")
        let myRequest = URLRequest(url: myUrl!)
        mainView.webView.load(myRequest)
    }
    
    @objc func goToPage(sender: UITextField) {
        if sender.text!.isEmpty {
            goToFirstPage()
        } else {
            if let myUrl = URL(string: sender.text!) {
                let myRequest = URLRequest(url: myUrl)
                mainView.webView.load(myRequest)
            } else {
                mainView.webView.reload()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func customGoBack(sender: UIButton) {
        if mainView.webView.canGoBack {
            print("Can go back")
            mainView.webView.goBack()
        } else {
            print("Can't go back")
        }
    }
    
    @objc func customGoForward(sender: UIButton) {
        if mainView.webView.canGoForward {
            print("Can go forward")
            mainView.webView.goForward()
        } else {
            print("Can't go forward")
        }
    }
}

//MARK: WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                if let url = navigationAction.request.url {
                    mainView.webView.load(URLRequest(url: url))
                    historyDelegate.addPage(url: url.absoluteString)
                }
            }
        decisionHandler(.allow)
     }
}

//MARK: UITextFieldDelegate

extension WebViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mainView.adressField {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
