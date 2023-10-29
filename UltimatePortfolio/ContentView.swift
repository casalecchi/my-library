//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Felipe Casalecchi on 16/10/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var books: [Book] {
        let filter = dataController.selectedFilter ?? .all
        var allBooks: [Book]
        
        if let tag = filter.tag {
            allBooks = tag.books?.allObjects as? [Book] ?? []
        } else {
            // all books - within the creation date is less than 1 week
            let request = Book.fetchRequest()
            // predicate will filter the request with some condition
            request.predicate = NSPredicate(format: "creationDate > %@", filter.minCreationDate as NSDate)
            // fetch the request using the viewContext
            allBooks = (try? dataController.container.viewContext.fetch(request)) ?? []
        }
        
        return allBooks.sorted()
    }
    
    var body: some View {
        List {
            ForEach(books) { book in
                BookRow(book: book)
            }
        }
        .navigationTitle("Books")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
