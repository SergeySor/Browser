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
    
    private var observationURL: NSKeyValueObservation?
    private var observationGoBack: NSKeyValueObservation?
    private var observationGoForward: NSKeyValueObservation?
    private var observationProgress: NSKeyValueObservation?
    
    override func loadView() {
        view = WebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.webView.uiDelegate = self
        mainView.webView.navigationDelegate = self
        mainView.adressField.delegate = self
        
        initObservations()
        initActions()
        goToFirstPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

//MARK: Setup

extension WebViewController {
    
    func initObservations() {
        
        observationURL = observe(\.mainView.webView.url) { _, _ in
            self.mainView.adressField.text = self.mainView.webView.url?.absoluteString
        }
        
        observationGoBack = observe(\.mainView.webView.canGoBack, changeHandler: { _, _ in
            self.mainView.backButton.isEnabled = self.mainView.webView.canGoBack
        })
        
        observationGoForward = observe(\.mainView.webView.canGoForward, changeHandler: { _, _ in
            self.mainView.forwardButton.isEnabled = self.mainView.webView.canGoForward
        })
        
        observationProgress = observe(\.mainView.webView.estimatedProgress, changeHandler: { _, _ in
            self.mainView.progressView.progress = Float(self.mainView.webView.estimatedProgress)
        })
    }
    
    func initActions() {
        
        mainView.adressField.addTarget(self, action: #selector(goToPage), for: .editingDidEnd)
        
        mainView.backButton.addTarget(self, action: #selector(customGoBack), for: .touchUpInside)
        
        mainView.forwardButton.addTarget(self, action: #selector(customGoForward), for: .touchUpInside)
    }
}

//MARK: Navigation actions

extension WebViewController {
    
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
