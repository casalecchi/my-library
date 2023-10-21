//
//  Book-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Felipe Casalecchi on 21/10/23.
//

import Foundation

extension Book {
    var bookTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    var bookContent: String {
        get { content ?? "" }
        set { content = newValue }
    }
    
    var bookCreationDate: Date {
        creationDate ?? Date.now
    }
    
    static var example: Book {
        // create an example book
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let book = Book(context: viewContext)
        book.title = "Example Book"
        book.content = "This is an example book."
        book.priority = 2
        book.creationDate = .now
        return book
    }
}
