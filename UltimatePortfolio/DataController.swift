//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Felipe Casalecchi on 16/10/23.
//

import CoreData

class DataController: ObservableObject {
    // container acts like an interface between the database and the code
    let container: NSPersistentCloudKitContainer
    
    @Published var selectedFilter: Filter? = Filter.all
    
    static var preview: DataController = {
        // sample data for previewing
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            // create data on memory and not on disk
            // will not be saved when app ends
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        // load the db on disk
        // or create if it doesn't exist
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Fatal Error: \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleData() {
        // viewContext of a container is used to read and write data in db
        // create new objects passing this viewContext
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(i)"
            
            for j in 1...10 {
                let book = Book(context: viewContext)
                book.title = "Book \(i)-\(j)"
                book.content = "Description of the book"
                book.completed = Bool.random()
                book.priority = Int16.random(in: 0...2)
                book.creationDate = .now
                tag.addToBooks(book)
            }
        }
        
        // CoreData write all this new objects
        try? viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        // announce that an object will change and then deletes it
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        // get all objects by a fetch request
        // wrap fetch request in a batch delete request -> CoreData will delete all objects in the request
        // execute the batch delete request -> needs very precise code
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        // set the return to be the objects IDs and not the objects itself
        // useful to know which objects will be deleted
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        // execute return some Result -> specify as NSBatchDeleteResult
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            // we will have an array of deleted objects IDs of type [NSManagedObjectID]
            // put that on a dict with this IDs as keys
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            // take the dict with the IDs and merge the changes on the viewContext
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        // Entity.fetchRequest will return all objects of an entity
        let tagRequest: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(tagRequest)
        
        let bookRequest: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()
        delete(bookRequest)
        
        save()
    }
}
