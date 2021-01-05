//
//  Persistence.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 15/11/20.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    //this is just for previews
    static var preview: PersistenceController = {
        var items = [Item]()
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.product_item_id = Int64(index)
            newItem.last_updated = Date()
            items.append(newItem)
        }

        //create PO
        let purchaseOrder = PurchaseOrder(context: viewContext)
        purchaseOrder.purchase_order_number = "P0"
        purchaseOrder.last_updated = Date()

        purchaseOrder.items = NSSet.init(array: items)
        purchaseOrder.invoices = NSSet()

        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error saving preview data: \(error), \(error.localizedDescription)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftUICoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error loading persistent data store \(error), \(error.localizedDescription)")
            }
        })
    }
}
