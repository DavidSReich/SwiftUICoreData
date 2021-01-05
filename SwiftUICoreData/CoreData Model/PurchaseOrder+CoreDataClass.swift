//
//  PurchaseOrder+CoreDataClass.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PurchaseOrder)
public class PurchaseOrder: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey {
        case delivery_note, issue_date, last_updated, preferred_delivery_date, purchase_order_number, items, invoices
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }
        let entity = NSEntityDescription.entity(forEntityName: "PurchaseOrder", in: context)!
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)

        delivery_note = try values.decode(String.self, forKey: .delivery_note)
        issue_date = try values.decode(Date.self, forKey: .issue_date)
        last_updated = try values.decode(Date.self, forKey: .last_updated)
        preferred_delivery_date = try values.decode(Date.self, forKey: .preferred_delivery_date)
        purchase_order_number = try values.decode(String.self, forKey: .purchase_order_number)
        let itemArray = try values.decode([Item].self, forKey: .items)
        items = NSSet(array: itemArray)
        let invoiceArray = try values.decode([Invoice].self, forKey: .invoices)
        invoices = NSSet(array: invoiceArray)
    }

    convenience public init() {
        self.init()
    }
}
