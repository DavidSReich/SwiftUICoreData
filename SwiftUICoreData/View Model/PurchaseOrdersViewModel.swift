//
//  PurchaseOrdersViewModel.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import CoreData

class PurchaseOrdersViewModel: ObservableObject {

    @Published var purchaseOrders = [PurchaseOrder]()
    @Published var isLoading = false
    @Published var showingAlert = false
    @Published var showingNewPurchase = false
    @Published var showingPurchaseOrder = false
    @Published var didLoadFromServer = false

    var errorString: String {
        lastReferenceError?.errorDescription ?? ""
    }

    private var lastReferenceError: ReferenceError?

    private var dataSource: DataSource
    private var coreDataService: CoreDataService

    init(viewContext: NSManagedObjectContext, dataSource: DataSource) {
        self.dataSource = dataSource
        coreDataService = CoreDataService(viewContext: viewContext)

        loadCoreData()
        updateFromServer()
    }

    func makePurchaseOrder() -> PurchaseOrder {
        return PurchaseOrder(context: coreDataService.viewContext)
    }

    // CREATE
    func saveItem(purchaseOrder: PurchaseOrder, productItemId: Int64, quantity: Int) {
        let now = Date()
        let newItem = Item(context: coreDataService.viewContext)
        newItem.product_item_id = productItemId
        newItem.quantity = Int64(quantity)
        newItem.last_updated = now
        newItem.purchaseOrder = purchaseOrder

        //>>>>>testing
        //>>>>>testing
        //this way modified items (not new ones) will be updated from the cloud
        if let items = purchaseOrder.items {
            for item in items {
                if let item = item as? Item {
                    item.quantity += 1
                    if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: item.last_updated) {
                        item.last_updated = newDate
                    }
                }
            }

            purchaseOrder.items = items
        }
        //<<<<<testing
        //<<<<<testing

        purchaseOrder.items?.adding(newItem)
        purchaseOrder.last_updated = now

        saveCoreData()
    }

    private func saveCoreData() {
        if let referenceError = coreDataService.saveCoreData() {
            lastReferenceError = referenceError
            showingAlert = true
        }
    }

    // CREATE
    func saveNewPurchaseOrder(newPurchaseOrderId: String, deliveryNote: String, preferredDate: Date) {
        let newPO = PurchaseOrder(context: coreDataService.viewContext)

        newPO.purchase_order_number = newPurchaseOrderId
        newPO.delivery_note = deliveryNote
        newPO.preferred_delivery_date = preferredDate
        let now = Date()
        newPO.last_updated = now
        newPO.issue_date = now

        saveCoreData()
    }

    // UPDATE
    func savePurchaseOrder() {
        guard coreDataService.hasChanges else { return }

        saveCoreData()
    }

    // DELETE
    func deleteItems(offsets: IndexSet) {
        offsets.map { purchaseOrders[$0] }.forEach(coreDataService.viewContext.delete)

        guard coreDataService.hasChanges else { return }

        saveCoreData()
    }

    // READ
    private func loadCoreData() {
        let fetchRequest: NSFetchRequest<PurchaseOrder> = PurchaseOrder.fetchRequest()

        do {
            let fetchedPurchaseOrders = try coreDataService.viewContext.fetch(fetchRequest)
            purchaseOrders = fetchedPurchaseOrders
        } catch let error {
            print("Could not fetch. \(error), \(error.localizedDescription)")
            showingAlert = true
            lastReferenceError = .coreData(error: error)
        }
    }

    private func updateFromServer() {
        guard !didLoadFromServer else { return }
        didLoadFromServer = true

        coreDataService.loadAndUpdateFromServer(purchaseOrders: purchaseOrders, errorHandler: { [self] referenceError in
            lastReferenceError = referenceError
            showingAlert = true
        })
   }
}

// for UserDefaults

//without some additional business logic this will potentially cause collisions with the backend
extension PurchaseOrdersViewModel {
    func getLastPurchaseOrderNumberUsed() -> Int {
        return UserDefaults.standard.integer(forKey: "last_purchase_order_number_used")
    }

    func setLastPurchaseOrderNumberUsed(lastPurchaseOrderNumber: Int) {
        UserDefaults.standard.set(lastPurchaseOrderNumber, forKey: "last_purchase_order_number_used")
    }
}
