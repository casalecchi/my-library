//
//  BookRow.swift
//  UltimatePortfolio
//
//  Created by Felipe Casalecchi on 28/10/23.
//

import SwiftUI

struct BookRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var book: Book
    
    var body: some View {
        NavigationLink(value: book) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(book.priority == 2 ? 1 : 0)
                
                VStack(alignment: .leading) {
                    Text(book.bookTitle)
                        .font(.headline)
                        .lineLimit(1)
                    Text("No tags")
                        .foregroundStyle(.secondary)
                        // no less than 2 and no more than 2
                        // good for keeping the same size of rows
                        //.lineLimit(2...2)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(book.bookCreationDate.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)
                    
                    if book.completed {
                        Text("COMPLETED")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    BookRow(book: Book.example)
        .environmentObject(DataController(inMemory: true))
}
