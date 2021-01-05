//
//  ReferenceErrorTests.swift
//  SwiftUICoreDataTests
//
//  Created by David S Reich on 3/1/21.
//  Copyright © 2021 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest
@testable import SwiftUICoreData

class ReferenceErrorTests: XCTestCase {

    func testErrors() {
        XCTAssertEqual(ReferenceError.apiNotHappy(message: "Bad API call").errorDescription,
                       "Bad API call")
        XCTAssertEqual(ReferenceError.badURL.errorDescription,
                       "Unable to construct a valid URL")
        XCTAssertEqual(ReferenceError.coreData(error: ReferenceError.noData).errorDescription,
                       "CoreData error: noData")
        XCTAssertEqual(ReferenceError.dataTask(error: ReferenceError.badURL).errorDescription,
                       "Error getting data: badURL")
        XCTAssertEqual(ReferenceError.decodeJSON(reason: "Bad JSON, bad JSON").errorDescription,
                       "Couldn't decode JSON: Bad JSON, bad JSON")
        XCTAssertEqual(ReferenceError.noData.errorDescription,
                       "Query did not return any data")
        XCTAssertEqual(ReferenceError.noFetchJSON(referenceError: ReferenceError.badURL).errorDescription,
                       "Couldn't fetch JSON: Unable to construct a valid URL")
        XCTAssertEqual(ReferenceError.noResponse.errorDescription,
                       "Query failed to return a response code")
        XCTAssertEqual(ReferenceError.notHttpURLResponse.errorDescription,
                       "Query response was not a Http URL response")
        XCTAssertEqual(ReferenceError.responseNot200(responseCode: 500, data: nil).errorDescription,
                       "Query failed with response code: 500")
        XCTAssertEqual(ReferenceError.wrongMimeType(targeMimeType: "Good Mime", receivedMimeType: "Bad Mime").errorDescription,
                       "Response was not Good Mime.  Was: Bad Mime")
    }
}
