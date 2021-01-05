//
//  InvoiceModel.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

struct InvoiceModel: Codable {
    var created: Date
    var invoice_number: String
    var last_updated: Date
    var received_status: Int16
    var receipts: [ReceiptModel]
}
