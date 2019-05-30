//
//  DataServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Sarannya on 26/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class LocalDataServiceTests : XCTestCase {
    
    var viewModel : ConverterViewModel!
    var dataSource : GenericDataSource<ConvertedRate>!
    var service : MockLocalDataService!


    override func setUp(){
        super.setUp()
        
        self.service = MockLocalDataService()
        self.dataSource = GenericDataSource<ConvertedRate>()
        self.viewModel = ConverterViewModel(dataSource: dataSource)
        self.viewModel.setServiceExplicitly(service: self.service)

    }
    
    override func tearDown() {
        self.service = nil
        self.dataSource = nil
        self.viewModel = nil
        super.tearDown()
    }
    
    func test_FetchLocalDataFromPath(){
        
        let expectation = XCTestExpectation(description: "Rates Fetch")

        let mockFilePath = "/var/mobile/Containers/xyz/Documents/ExchangeRates.json"
        service.filepath = URL(string: mockFilePath)
        
        viewModel.errorResult = { error in
            XCTAssert(false, "cannot fetch from path")
        }
        
        viewModel.fetchData {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

    }
    
    func test_FetchLocalDataFrom_WronPath(){
        
        let expectation = XCTestExpectation(description: "Data Fetch Fails")
        
        service.filepath = nil
        
        //expected to fail
        viewModel.errorResult = { error in
            expectation.fulfill()
        }
        
        viewModel.fetchData {
        }
        wait(for: [expectation], timeout: 5.0)
    }
}

//MARK:- MockLocalDataService with mock data
class MockLocalDataService : DataFetchServiceProtocol{
    
    var filepath : URL?
    let expectedData = [ConvertedRate(currencyName: "EUR", rate: 1.0000)]

    func fetchExchangeRates(_ completion: @escaping ((Result<[ConvertedRate], ErrorResult>) -> Void)) {
        
        if filepath != nil {
            completion(Result.success(expectedData))
        }else{
            completion(Result.failure(.custom(string: "no file at path")))
        }
        
    }
    
    
}
