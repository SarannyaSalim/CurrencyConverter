//
//  ConverterViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Sarannya on 26/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class ConverterViewModelTests : XCTestCase{
    
    var viewModel : ConverterViewModel!
    var dataSource : GenericDataSource<ConvertedRate>!
    var service : MockDataFetchService!
    
    override func setUp() {
        super.setUp()
        
        self.service = MockDataFetchService()
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
    
    
    func test_FetchWithNoService(){
        
        let expectation = XCTestExpectation(description: "No service found")
        viewModel.setServiceExplicitly(service: nil)
        
        //should fail with error when Service unavailable
        viewModel.errorResult = { error in
            expectation.fulfill()
        }
        
        viewModel.fetchData {}
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FetchExchangeRates(){
        
        let expectation = XCTestExpectation(description: "Rates Fetch")
        
        //Mock rates
        service.exchagaRateData = [ConvertedRate(currencyName: "USD", rate: 1.1265)]
        viewModel.errorResult = { _ in
            XCTAssert(false, "Fetch fail without service")
        }
        
        viewModel.fetchData {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FetchNoExhangeRates(){
        let expectation = XCTestExpectation(description: "No Rates Fetch")
       
        service.exchagaRateData = nil
        
        viewModel.errorResult = { _ in
           
            //no data fetched
            expectation.fulfill()
        }
        viewModel.fetchData {}
        wait(for: [expectation], timeout: 5.0)
    }
}



//MARK:- Mock service object
class MockDataFetchService : DataFetchServiceProtocol{
    
    var exchagaRateData : [ConvertedRate]?
    
    func fetchExchangeRates(_ completion: @escaping ((Result<[ConvertedRate], ErrorResult>) -> Void)) {
        
        if let exchangeRates = exchagaRateData {
            completion(Result.success(exchangeRates))
        }else{
            completion(Result.failure(ErrorResult.custom(string: "No data fetched")))
        }
    }
    
    
}
