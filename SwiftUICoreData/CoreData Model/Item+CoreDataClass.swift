//
//  Item+CoreDataClass.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey {
        case last_updated, product_item_id, quantity
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)

        last_updated = try values.decode(Date.self, forKey: .last_updated)
        product_item_id = try values.decode(Int64.self, forKey: .product_item_id)
        quantity = try values.decode(Int64.self, forKey: .quantity)
    }
}
