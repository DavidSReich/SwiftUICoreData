//
//  Invoice+CoreDataClass.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Invoice)
public class Invoice: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey {
        case created, invoice_number, last_updated, received_status, receipts
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }
        let entity = NSEntityDescription.entity(forEntityName: "Invoice", in: context)!
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)

        created = try values.decode(Date.self, forKey: .created)
        invoice_number = try values.decode(String.self, forKey: .invoice_number)
        last_updated = try values.decode(Date.self, forKey: .last_updated)
        received_status = try values.decode(Int16.self, forKey: .received_status)
        let receiptArray = try values.decode([Receipt].self, forKey: .receipts)
        receipts = NSSet(array: receiptArray)
    }
}
