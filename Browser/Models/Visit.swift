//
//  Visit.swift
//  Browser
//
//  Created by Sergey Sorokin on 31.03.2021.
//

import Foundation
import RealmSwift

class Visit: Object {
    @objc dynamic var url = ""
    @objc dynamic var date = Date()
}
