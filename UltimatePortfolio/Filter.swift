//
//  Filter.swift
//  UltimatePortfolio
//
//  Created by Felipe Casalecchi on 20/10/23.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minCreationDate = Date.distantPast
    var tag: Tag?
    
    static var all = Filter(id: UUID(), name: "All books", icon: "tray")
    static var recent = Filter(id: UUID(), name: "Recent books", icon: "clock", minCreationDate: .now.addingTimeInterval(86400 * -7))
    
    func hash(into hasher: inout Hasher) {
        // function used to calculate the hash value
        hasher.combine(id)
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
