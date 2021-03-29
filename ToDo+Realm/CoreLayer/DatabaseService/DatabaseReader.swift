//
//  DatabaseReader.swift
//  Backyard
//
//  Created by Evgenia Sleptsova on 17/07/2019.
//

import Foundation
import RealmSwift

protocol DatabaseReader {

    func read<T: Object>() -> [T]

    func read<T: Object>(sortedBy: String, ascending: Bool) -> [T]
    
    func read<T: Object>(filter: NSPredicate) -> [T]
}
