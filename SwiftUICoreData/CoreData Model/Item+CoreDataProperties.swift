//
//  Item+CoreDataProperties.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var last_updated: Date
    @NSManaged public var product_item_id: Int64
    @NSManaged public var quantity: Int64
    @NSManaged public var purchaseOrder: PurchaseOrder

}

extension Item : Identifiable {

}
