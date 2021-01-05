//
//  InvoiceModelTests.swift
//  SwiftUICoreDataTests
//
//  Created by David S Reich on 31/12/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest
@testable import SwiftUICoreData

class InvoiceModelTests: XCTestCase {

    func testInvoiceModel() {
        let jsonData = BaseTestUtilities.getInvoiceModelData()

        let result: Result<InvoiceModel, ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let invoiceModel):
            XCTAssertEqual(BaseTestUtilities.getTestLastUpdatedDate(), invoiceModel.created)
            XCTAssertEqual(BaseTestUtilities.invoiceNumber, invoiceModel.invoice_number)
            XCTAssertEqual(BaseTestUtilities.getTestLastUpdatedDate(), invoiceModel.last_updated)
            XCTAssertEqual(BaseTestUtilities.receivedStatus, invoiceModel.received_status)
            XCTAssertEqual(1, invoiceModel.receipts.count)

            let receipt = invoiceModel.receipts[0]
            XCTAssertEqual(BaseTestUtilities.receiptProductItemId, receipt.product_item_id)
        case .failure(let referenceError):
            XCTFail("Could not decode InvoiceModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }
}
