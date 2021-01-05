//
//  CoreDataService.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 26/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import CoreData


struct CoreDataService {
    var viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    var hasChanges: Bool {
        viewContext.hasChanges
    }

    func saveCoreData() -> ReferenceError? {
        do {
            try viewContext.save()
            return nil
        } catch {
            return .coreData(error: error)
        }
    }

    //we can do this because we are creating a new PurchaseOrder or completely replacing an existing one.
    private func convertPurchaseOrderModelToPurchaseOrderInCoreData(newPurchaseOrder: PurchaseOrderModel) -> Bool {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.iso8601MSec)
        if let purchaseOrderData = try? encoder.encode(newPurchaseOrder) {
            let result: Result<PurchaseOrder, ReferenceError> = purchaseOrderData.decodeData()

            if case .success = result {
                //should already be queued up inside CoreData ... just needs a save
                return true
            }
        }

        return false
    }

    func loadAndUpdateFromServer(purchaseOrders: [PurchaseOrder], errorHandler: @escaping (ReferenceError) -> Void) {
        var saveToCoreData = false

        let dataSource = DataSource(networkService: NetworkService())
        dataSource.getData(urlString: "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders",
                           mimeType: "application/json") { refError in
            if let referenceError = refError {
                errorHandler(referenceError)
                return
            }

            let now = Date()
            let newPurchaseOrders = dataSource.getPurchaseOrders()

            for newPO in newPurchaseOrders {
                let oldPOs = purchaseOrders.filter({ $0.purchase_order_number == newPO.purchase_order_number })
                if let oldPO = oldPOs.first {
                    if oldPO.last_updated < newPO.last_updated {
                        //do the entire purchaseorder.
                        //delete the old one
                        self.viewContext.delete(oldPO)
                        //this should insert the new PO
                        if self.convertPurchaseOrderModelToPurchaseOrderInCoreData(newPurchaseOrder: newPO) {
                            saveToCoreData = true
                        }

                        //continue even if convert failed
                        continue
                    }

                    //we didn't do the whole purchase order so

                    //lets look at each Item!
                    if self.updateNewerItems(oldPO: oldPO, itemModels: newPO.items, now: now) {
                        saveToCoreData = true
                    }

                    //then at each invoice
                    if self.updateNewerInvoices(oldPO: oldPO, ivoiceModels: newPO.invoices, now: now) {
                        saveToCoreData = true
                    }
                } else {
                    //do the entire purchaseorder.
                    //this should automatically insert the new PO
                    if self.convertPurchaseOrderModelToPurchaseOrderInCoreData(newPurchaseOrder: newPO) {
                        saveToCoreData = true
                    }
                }
            }

            if saveToCoreData && self.viewContext.hasChanges {
                if let referenceError = self.saveCoreData() {
                    errorHandler(referenceError)
                }
            }
        }
    }

    private func updateNewerInvoices(oldPO: PurchaseOrder, ivoiceModels: [InvoiceModel], now: Date) -> Bool {
        var saveToCoreData = false

        for invoiceModel in ivoiceModels {
            if let oldInvoice = oldPO.invoices?.filter({ ($0 as? Invoice)?.invoice_number == invoiceModel.invoice_number }).first as? Invoice {
                if oldInvoice.last_updated < invoiceModel.last_updated {
                    updateInvoice(invoice: oldInvoice, invoiceModel: invoiceModel)
                    saveToCoreData = true
                    //saved updated
                    //next new item
                }

                //have old invoice, but didn't modify it

                if updateNewerReceipts(oldInvoice: oldInvoice, receiptModels: invoiceModel.receipts, now: now) {
                    saveToCoreData = true
                }

                //next new invoice
                continue
            }

            // it's a brand new invoice -- add it
            let newInvoice = Invoice(context: viewContext)
            updateInvoice(invoice: newInvoice, invoiceModel: invoiceModel)

            if oldPO.invoices == nil {
                oldPO.invoices = NSSet()
            }

            oldPO.invoices?.adding(newInvoice)
            saveToCoreData = true
        }

        return saveToCoreData
    }

    //either we are always copying the entire invoice or setting the entire new invoice
    private func updateInvoice(invoice: Invoice, invoiceModel: InvoiceModel) {
        invoice.created = invoiceModel.created
        invoice.invoice_number = invoiceModel.invoice_number
        invoice.last_updated = invoiceModel.last_updated
        invoice.received_status = invoiceModel.received_status

        var receipts = [Receipt]()

        for receiptModel in invoiceModel.receipts {
            let newReceipt = Receipt(context: viewContext)
            newReceipt.product_item_id = receiptModel.product_item_id
            newReceipt.received_quantity = receiptModel.received_quantity
            newReceipt.last_updated = receiptModel.last_updated
            newReceipt.invoice = invoice

            receipts.append(newReceipt)
        }

        invoice.receipts = NSSet.init(array: receipts)
    }

    private func updateNewerItems(oldPO: PurchaseOrder, itemModels: [ItemModel], now: Date) -> Bool {
        var saveToCoreData = false

        for itemModel in itemModels {
            if let oldItem = oldPO.items?.filter({ ($0 as? Item)?.product_item_id == itemModel.product_item_id }).first as? Item {
                if oldItem.last_updated < itemModel.last_updated {
                    oldItem.last_updated = itemModel.last_updated
                    oldItem.quantity = itemModel.quantity
                    saveToCoreData = true
                    //saved updated
                    //next new item
                }

                //have old item, but didn't modify it
                //next new item
                continue
            }

            // it's a brand new item -- add it
            let newItem = Item(context: viewContext)
            newItem.product_item_id = itemModel.product_item_id
            newItem.quantity = itemModel.quantity
            newItem.last_updated = now
            newItem.purchaseOrder = oldPO

            if oldPO.items == nil {
                oldPO.items = NSSet()
            }

            oldPO.items?.adding(newItem)
            saveToCoreData = true
        }

        return saveToCoreData
    }

    private func updateNewerReceipts(oldInvoice: Invoice, receiptModels: [ReceiptModel], now: Date) -> Bool {
        var saveToCoreData = false

        for receiptModel in receiptModels {
            if let oldReceipt = oldInvoice.receipts?.filter({ ($0 as? Receipt)?.product_item_id == receiptModel.product_item_id }).first as? Receipt {
                if oldReceipt.last_updated < receiptModel.last_updated {
                    oldReceipt.last_updated = receiptModel.last_updated
                    oldReceipt.received_quantity = receiptModel.received_quantity
                    saveToCoreData = true
                    //saved updated
                    //next new receipt
                }

                //have old receipt, but didn't modify it
                //next new receipt
                continue
            }

            // it's a brand new receipt -- add it
            let newReceipt = Receipt(context: viewContext)
            newReceipt.product_item_id = receiptModel.product_item_id
            newReceipt.received_quantity = receiptModel.received_quantity
            newReceipt.last_updated = now
            newReceipt.invoice = oldInvoice

            if oldInvoice.receipts == nil {
                oldInvoice.receipts = NSSet()
            }

            oldInvoice.receipts?.adding(newReceipt)
            saveToCoreData = true
        }

        return saveToCoreData
    }
}
