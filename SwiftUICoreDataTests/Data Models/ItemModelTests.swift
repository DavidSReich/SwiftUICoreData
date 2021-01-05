//
//  ItemModelTests.swift
//  SwiftUICoreDataTests
//
//  Created by David S Reich on 31/12/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest
@testable import SwiftUICoreData

class ItemModelTests: XCTestCase {

    func testItemModel() {
        let jsonData = BaseTestUtilities.getItemModelData()

        let result: Result<ItemModel, ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let itemModel):
            XCTAssertEqual(BaseTestUtilities.getTestLastUpdatedDate(), itemModel.last_updated)
            XCTAssertEqual(BaseTestUtilities.itemProductItemId, itemModel.product_item_id)
            XCTAssertEqual(BaseTestUtilities.itemQuantity, itemModel.quantity)
        case .failure(let referenceError):
            XCTFail("Could not decode ItemModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }
}
