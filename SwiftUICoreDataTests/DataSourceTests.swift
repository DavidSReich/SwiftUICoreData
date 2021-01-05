//
//  DataSourceTests.swift
//  SwiftUICoreDataTests
//
//  Created by David S Reich on 3/1/21.
//  Copyright © 2021 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest
@testable import SwiftUICoreData

class DataSourceTests: XCTestCase {

    func testDataSource() {
        let dataSource = DataSource(networkService: MockNetworkService(mockedData: BaseTestUtilities.getPurchaseOrderModelsData()))
        dataSource.getData(urlString: "urlstring",
                           mimeType: "") { refError in
            if let referenceError = refError {
                XCTFail("Could not get mock PurchaseOrderModels data. - \(String(describing: referenceError.errorDescription))")
                return
            }

            let purchaseOrderModels = dataSource.getPurchaseOrders()
            XCTAssertEqual(2, purchaseOrderModels.count)

            PurchaseOrderModelTests.purchaseOrderTest(purchaseOrderModel: purchaseOrderModels[1])
        }
    }
}
