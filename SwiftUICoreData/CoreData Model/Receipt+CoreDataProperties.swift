//
//  Receipt+CoreDataProperties.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var last_updated: Date
    @NSManaged public var product_item_id: Int64
    @NSManaged public var received_quantity: Int64
    @NSManaged public var invoice: Invoice

}

extension Receipt : Identifiable {

}
