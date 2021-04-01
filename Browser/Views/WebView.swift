//
//  WebView.swift
//  Browser
//
//  Created by Sergey Sorokin on 30.03.2021.
//

import Foundation
import UIKit
import SnapKit
import WebKit

class WebView: UIView {
    
    let webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        return button
    }()
    
    let adressField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.textColor = .white
        view.textAlignment = .center
        view.borderStyle = .roundedRect
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(topView)
        addSubview(webView)
        addSubview(adressField)
        addSubview(backButton)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(safeAreaInsets.top + 50.0)
        }
        
        webView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        adressField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(50.0)
            make.bottom.equalTo(topView.snp.bottom).inset(10.0)
            make.height.equalTo(25.0)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(adressField)
            make.left.equalToSuperview()
            make.right.equalTo(adressField.snp.left)
        }
    }
}
