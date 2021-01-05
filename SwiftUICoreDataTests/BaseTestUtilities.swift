//
//  BaseTestUtilities.swift
//  SwiftUICoreDataTests
//
//  Created by David S Reich on 30/12/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import Combine
@testable import SwiftUICoreData

class BaseTestUtilities {
    static private let testLastUpdatedString = "2020-05-07T09:32:28.213Z"

    static let itemProductItemId = Int64(12)
    static let itemQuantity = Int64(12)
    static private let itemLastUpdatedString = testLastUpdatedString

    static let receiptProductItemId = Int64(111)
    static let receiptReceivedQuantity = Int64(22)
    static private let receiptLastUpdatedString = testLastUpdatedString

    static private func itemModelString() -> String {
        return """
        {
            "id": 1,
            "product_item_id": \(itemProductItemId),
            "quantity": \(itemQuantity),
            "last_updated_user_entity_id": 200,
            "transient_identifier": "tid",
            "active_flag": true,
            "last_updated": "\(itemLastUpdatedString)"
        }
        """
    }

    static private func receiptModelString() -> String {
        return """
        {
            "id": 110,
            "product_item_id": \(receiptProductItemId),
            "received_quantity": \(receiptReceivedQuantity),
            "created": "2020-05-07T09:32:28.213Z",
            "last_updated_user_entity_id": 10,
            "transient_identifier": "tid2",
            "sent_date": "2020-05-07T09:32:28.213Z",
            "active_flag": true,
            "last_updated": "\(receiptLastUpdatedString)"
        }
        """
    }

    /*
     var created: Date
     var invoice_number: String
     var last_updated: Date
     var received_status: Int16
     var receipts: [ReceiptModel]
     */
    static private let invoiceLastUpdatedString = testLastUpdatedString
    static let invoiceNumber = "10101"
    static private let invoiceCreatedString = testLastUpdatedString
    static let receivedStatus = Int16(2)

    static private func invoiceModelString() -> String {
        return """
        {
            "id": 11,
            "invoice_number": "\(invoiceNumber)",
            "received_status": \(receivedStatus),
            "created": "\(invoiceCreatedString)",
            "last_updated_user_entity_id": 10,
            "transient_identifier": "tid",
            "receipts": [
                \(receiptModelString())
            ],
            "receipt_sent_date": "2020-05-07T09:32:28.213Z",
            "active_flag": true,
            "last_updated": "\(invoiceLastUpdatedString)"
        }
        """
    }

    static private let purchaseOrderLastUpdatedString = testLastUpdatedString
    static let purchaseOrderNumber = "201"
    static private func purchaseOrderModelString() -> String {
        return """
        {
            "id": 1,
            "supplier_id": 11,
            "purchase_order_number": "\(purchaseOrderNumber)",
            "stock_purchase_process_ids": [
                0
            ],
            "issue_date": "2020-05-07T09:32:28.213Z",
            "items": [
                {
                    "id": 1,
                    "product_item_id": 1,
                    "quantity": 10,
                    "last_updated_user_entity_id": 200,
                    "transient_identifier": "tid",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                },
                {
                    "id": 2,
                    "product_item_id": 2,
                    "quantity": 10,
                    "last_updated_user_entity_id": 200,
                    "transient_identifier": "tid",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                },
                {
                    "id": 3,
                    "product_item_id": 3,
                    "quantity": 10,
                    "last_updated_user_entity_id": 200,
                    "transient_identifier": "tid",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                },
                {
                    "id": 4,
                    "product_item_id": 4,
                    "quantity": 10,
                    "last_updated_user_entity_id": 200,
                    "transient_identifier": "tid",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                },
                \(itemModelString())
            ],
            "invoices": [
                {
                    "id": 11,
                    "invoice_number": "101",
                    "received_status": 1,
                    "created": "2020-05-07T09:32:28.213Z",
                    "last_updated_user_entity_id": 10,
                    "transient_identifier": "tid",
                    "receipts": [
                        {
                            "id": 110,
                            "product_item_id": 110,
                            "received_quantity": 20,
                            "created": "2020-05-07T09:32:28.213Z",
                            "last_updated_user_entity_id": 10,
                            "transient_identifier": "tid2",
                            "sent_date": "2020-05-07T09:32:28.213Z",
                            "active_flag": true,
                            "last_updated": "2020-05-07T09:32:28.213Z"
                        }
                    ],
                    "receipt_sent_date": "2020-05-07T09:32:28.213Z",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                },
                \(invoiceModelString())
            ],
            "cancellations": [
                {
                "id": 1,
                    "product_item_id": 2,
                    "ordered_quantity": 11,
                    "last_updated_user_entity_id": 0,
                    "created": "2020-05-07T09:32:28.213Z",
                    "transient_identifier": "string"
                }
            ],
            "status": 1,
            "active_flag": true,
            "last_updated": "\(purchaseOrderLastUpdatedString)",
            "last_updated_user_entity_id": 0,
            "sent_date": "2020-05-07T09:32:28.213Z",
            "server_timestamp": 0,
            "device_key": "string",
            "approval_status": 1,
            "preferred_delivery_date": "2020-05-07T09:32:28.213Z",
            "delivery_note": "string"
        }
        """
    }

    static private let purchaseOrder0 =
    #"""
        {
            "id": 1,
            "supplier_id": 11,
            "purchase_order_number": "200",
            "stock_purchase_process_ids": [
                0
            ],
            "issue_date": "2020-05-07T09:32:28.213Z",
            "items": [
                {
                    "id": 1,
                    "product_item_id": 1,
                    "quantity": 10,
                    "last_updated_user_entity_id": 200,
                    "transient_identifier": "tid",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                },
                {
                    "id": 2,
                    "product_item_id": 2,
                    "quantity": 10,
                    "last_updated_user_entity_id": 200,
                    "transient_identifier": "tid",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                },
                {
                    "id": 3,
                    "product_item_id": 3,
                    "quantity": 10,
                    "last_updated_user_entity_id": 200,
                    "transient_identifier": "tid",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                },
                {
                    "id": 4,
                    "product_item_id": 4,
                    "quantity": 10,
                    "last_updated_user_entity_id": 200,
                    "transient_identifier": "tid",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                }
            ],
            "invoices": [
                {
                    "id": 11,
                    "invoice_number": "101",
                    "received_status": 1,
                    "created": "2020-05-07T09:32:28.213Z",
                    "last_updated_user_entity_id": 10,
                    "transient_identifier": "tid",
                    "receipts": [
                        {
                            "id": 110,
                            "product_item_id": 110,
                            "received_quantity": 20,
                            "created": "2020-05-07T09:32:28.213Z",
                            "last_updated_user_entity_id": 10,
                            "transient_identifier": "tid2",
                            "sent_date": "2020-05-07T09:32:28.213Z",
                            "active_flag": true,
                            "last_updated": "2020-05-07T09:32:28.213Z"
                        }
                    ],
                    "receipt_sent_date": "2020-05-07T09:32:28.213Z",
                    "active_flag": true,
                    "last_updated": "2020-05-07T09:32:28.213Z"
                }
            ],
            "cancellations": [
                {
                "id": 1,
                    "product_item_id": 2,
                    "ordered_quantity": 11,
                    "last_updated_user_entity_id": 0,
                    "created": "2020-05-07T09:32:28.213Z",
                    "transient_identifier": "string"
                }
            ],
            "status": 1,
            "active_flag": true,
            "last_updated": "2020-05-07T09:32:28.213Z",
            "last_updated_user_entity_id": 0,
            "sent_date": "2020-05-07T09:32:28.213Z",
            "server_timestamp": 0,
            "device_key": "string",
            "approval_status": 1,
            "preferred_delivery_date": "2020-05-07T09:32:28.213Z",
            "delivery_note": "string"
        }
    """#

    static private func purchaseOrderModelsString() -> String {
        return """
            [
                \(purchaseOrder0),
                \(purchaseOrderModelString())
            ]
        """
    }

    class func getItemModelData() -> Data {
        return Data(itemModelString().utf8)
    }

    class func getReceiptModelData() -> Data {
        return Data(receiptModelString().utf8)
    }

    class func getInvoiceModelData() -> Data {
        return Data(invoiceModelString().utf8)
    }

    class func getPurchaseOrderModelData() -> Data {
        return Data(purchaseOrderModelString().utf8)
    }

    class func getPurchaseOrderModelsData() -> Data {
        return Data(purchaseOrderModelsString().utf8)
    }

    class func getTestLastUpdatedDate() -> Date {
        return DateFormatter.iso8601MSec.date(from: testLastUpdatedString) ?? Date()
    }
}

class MockNetworkService: NetworkService {
    let mockedData: Data

    init(mockedData: Data) {
        self.mockedData = mockedData
    }

    override func getDataPublisher(urlString: String, mimeType: String) -> DataPublisher? {
        return Just(mockedData)
            .setFailureType(to: ReferenceError.self)
            .eraseToAnyPublisher()
    }
}
