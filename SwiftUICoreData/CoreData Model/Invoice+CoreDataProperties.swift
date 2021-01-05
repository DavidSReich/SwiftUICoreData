//
//  Invoice+CoreDataProperties.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension Invoice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged public var created: Date
    @NSManaged public var invoice_number: String
    @NSManaged public var last_updated: Date
    @NSManaged public var received_status: Int16
    @NSManaged public var purchaseOrder: PurchaseOrder
    @NSManaged public var receipts: NSSet?

}

// MARK: Generated accessors for receipts
extension Invoice {

    @objc(addReceiptsObject:)
    @NSManaged public func addToReceipts(_ value: Receipt)

    @objc(removeReceiptsObject:)
    @NSManaged public func removeFromReceipts(_ value: Receipt)

    @objc(addReceipts:)
    @NSManaged public func addToReceipts(_ values: NSSet)

    @objc(removeReceipts:)
    @NSManaged public func removeFromReceipts(_ values: NSSet)

}

extension Invoice : Identifiable {

}
