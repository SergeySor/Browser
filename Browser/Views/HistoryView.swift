//
//  HistoryView.swift
//  Browser
//
//  Created by Sergey Sorokin on 31.03.2021.
//

import Foundation
import UIKit
import SnapKit

class HistoryView: UIView {
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let header: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(topView)
        addSubview(header)
        addSubview(tableView)
        
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
        
        header.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(topView.snp.bottom).inset(10.0)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
    }
}
