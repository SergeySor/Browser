//
//  HistoryViewController.swift
//  Browser
//
//  Created by Sergey Sorokin on 31.03.2021.
//

import Foundation
import UIKit
import RealmSwift

class HistoryViewController: UIViewController, HistoryDelegate {
    
    private var mainView: HistoryView {
        return view as! HistoryView
    }
    
    private lazy var visits = { realm.objects(Visit.self).sorted { (first, second) -> Bool in
        return first.date > second.date
    }
    }()
    
    private lazy var realm = try! Realm()
    
    override func loadView() {
        view = HistoryView()
        
        mainView.header.text = navigationItem.title
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "outh")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

//MARK: Realm actions

extension HistoryViewController {
    
    func addPage(url: String) {
        let newVisit = Visit()
        newVisit.url = url
        do {
            try addVisitToRealm(visit: newVisit)
            let indexPathNewRow = IndexPath(row: visits.count - 1, section: 0)
            mainView.tableView.insertRows(at: [indexPathNewRow], with: .automatic)
        } catch {
            print("can't add new visit to realm")
        }
    }
    
    func addVisitToRealm(visit: Visit) throws {
        try realm.write() {
            realm.add(visit)
        }
        
        if !visits.contains(visit) {
            visits.append(visit)
        }
    }
    
    func handleMoveToTrash(index: IndexPath) {
        do {
            realm.beginWrite()
            realm.delete(visits.remove(at: index.row))
            try realm.commitWrite()
            mainView.tableView.deleteRows(at: [index], with: .fade)
        } catch {
            print("can't delete")
        }
    }
}

//MARK: UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive, title: "Trash") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(index: indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
    }
}

//MARK: UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainView.tableView.dequeueReusableCell(withIdentifier: "outh", for: indexPath)
        
        cell.textLabel?.text = visits[indexPath.row].url
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
