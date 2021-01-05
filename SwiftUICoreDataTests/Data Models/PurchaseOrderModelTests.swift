//
//  PurchaseOrderModelTests.swift
//  SwiftUICoreDataTests
//
//  Created by David S Reich on 3/1/21.
//  Copyright © 2021 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest
@testable import SwiftUICoreData

class PurchaseOrderModelTests: XCTestCase {

    func testPurchaseOrderModel() {
        let jsonData = BaseTestUtilities.getPurchaseOrderModelData()

        let result: Result<PurchaseOrderModel, ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let purchaseOrderModel):
            PurchaseOrderModelTests.purchaseOrderTest(purchaseOrderModel: purchaseOrderModel)
        case .failure(let referenceError):
            XCTFail("Could not decode PurchaseOrderModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }

    func testPurchaseOrderModels() {
        let jsonData = BaseTestUtilities.getPurchaseOrderModelsData()

        let result: Result<[PurchaseOrderModel], ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let purchaseOrderModels):
            XCTAssertEqual(2, purchaseOrderModels.count)
            PurchaseOrderModelTests.purchaseOrderTest(purchaseOrderModel: purchaseOrderModels[1])
        case .failure(let referenceError):
            XCTFail("Could not decode PurchaseOrderModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }

    class func purchaseOrderTest(purchaseOrderModel: PurchaseOrderModel) {
        XCTAssertEqual(BaseTestUtilities.purchaseOrderNumber, purchaseOrderModel.purchase_order_number)
        XCTAssertEqual(BaseTestUtilities.getTestLastUpdatedDate(), purchaseOrderModel.last_updated)
        XCTAssertEqual(5, purchaseOrderModel.items.count)
        XCTAssertEqual(2, purchaseOrderModel.invoices.count)

        let itemModel = purchaseOrderModel.items[4]

        XCTAssertEqual(BaseTestUtilities.getTestLastUpdatedDate(), itemModel.last_updated)
        XCTAssertEqual(BaseTestUtilities.itemProductItemId, itemModel.product_item_id)
        XCTAssertEqual(BaseTestUtilities.itemQuantity, itemModel.quantity)

        let invoiceModel = purchaseOrderModel.invoices[1]

        XCTAssertEqual(BaseTestUtilities.getTestLastUpdatedDate(), invoiceModel.created)
        XCTAssertEqual(BaseTestUtilities.invoiceNumber, invoiceModel.invoice_number)
        XCTAssertEqual(BaseTestUtilities.getTestLastUpdatedDate(), invoiceModel.last_updated)
        XCTAssertEqual(BaseTestUtilities.receivedStatus, invoiceModel.received_status)
        XCTAssertEqual(1, invoiceModel.receipts.count)

        let receipt = invoiceModel.receipts[0]
        XCTAssertEqual(BaseTestUtilities.receiptProductItemId, receipt.product_item_id)
    }
}
