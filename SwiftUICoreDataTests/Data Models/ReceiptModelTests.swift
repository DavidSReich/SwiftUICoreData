//
//  ReceiptModelTests.swift
//  SwiftUICoreDataTests
//
//  Created by David S Reich on 31/12/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest
@testable import SwiftUICoreData

class ReceiptModelTests: XCTestCase {

    func testReceiptModel() {
        let jsonData = BaseTestUtilities.getReceiptModelData()

        let result: Result<ReceiptModel, ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let receiptModel):
            XCTAssertEqual(BaseTestUtilities.getTestLastUpdatedDate(), receiptModel.last_updated)
            XCTAssertEqual(BaseTestUtilities.receiptProductItemId, receiptModel.product_item_id)
            XCTAssertEqual(BaseTestUtilities.receiptReceivedQuantity, receiptModel.received_quantity)
        case .failure(let referenceError):
            XCTFail("Could not decode ReceiptModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }
}
