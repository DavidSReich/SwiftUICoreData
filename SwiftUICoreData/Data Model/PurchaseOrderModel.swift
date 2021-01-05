//
//  PurchaseOrderModel.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

struct PurchaseOrderModel: Codable {
    var delivery_note: String
    var issue_date: Date
    var last_updated: Date
    var preferred_delivery_date: Date
    var purchase_order_number: String
    var invoices: [InvoiceModel]
    var items: [ItemModel]
}
