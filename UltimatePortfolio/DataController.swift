//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by mnameit on 22/06/23.
//

import CoreData

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    @Published var selectedFilter: Filter? = Filter.all
    
    static var preview: DataController = {
       let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleData() {
        let context = container.viewContext
        
        for i in 1...5 {
            let tag = Tag(context: context)
            tag.id = UUID()
            tag.name = "Tag \(i)"
            
            for j in 1...10 {
                let issue = Issue(context: context)
                issue.title = "Issue \(i)-\(j)"
                issue.content = "Description goes here"
                issue.creationDate = .now
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
                tag.addToIssues(issue)
            }
        }
        try? context.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let deleteBatchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteBatchRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(deleteBatchRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(fetchRequest: request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(fetchRequest: request2)
        
        save()
        
    }
}
