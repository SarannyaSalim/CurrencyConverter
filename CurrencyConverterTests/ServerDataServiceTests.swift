//
//  ServerDataServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Sarannya on 26/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import XCTest
@testable import CurrencyConverter


class ServerDataServiceTests: XCTestCase {
    
    func test_CancelRequest() {
        
        // giving a "previous" session
        ServerDataFetchService.shared.fetchExchangeRates({ _ in
            // ignore call
        })
        
        // Expected to set task nil after cancel
        ServerDataFetchService.shared.cancelPreviousTask()
        XCTAssertNil(ServerDataFetchService.shared.task, "Expected task nil")
    }
}

//Note: All Other tests for ServerDataService are implemeted in ConverterViewModelTests, with dependency injection
