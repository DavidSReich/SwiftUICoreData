//
//  ItemModel.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

struct ItemModel: Codable {
    var last_updated: Date
    var product_item_id: Int64
    var quantity: Int64
}
