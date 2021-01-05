//
//  PurchaseOrder+CoreDataProperties.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension PurchaseOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PurchaseOrder> {
        return NSFetchRequest<PurchaseOrder>(entityName: "PurchaseOrder")
    }

    @NSManaged public var delivery_note: String
    @NSManaged public var issue_date: Date
    @NSManaged public var last_updated: Date
    @NSManaged public var preferred_delivery_date: Date
    @NSManaged public var purchase_order_number: String
    @NSManaged public var invoices: NSSet?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for invoices
extension PurchaseOrder {

    @objc(addInvoicesObject:)
    @NSManaged public func addToInvoices(_ value: Invoice)

    @objc(removeInvoicesObject:)
    @NSManaged public func removeFromInvoices(_ value: Invoice)

    @objc(addInvoices:)
    @NSManaged public func addToInvoices(_ values: NSSet)

    @objc(removeInvoices:)
    @NSManaged public func removeFromInvoices(_ values: NSSet)

    @NSManaged public var lastProductItemId: Int16
}

// MARK: Generated accessors for items
extension PurchaseOrder {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension PurchaseOrder : Identifiable {

}
