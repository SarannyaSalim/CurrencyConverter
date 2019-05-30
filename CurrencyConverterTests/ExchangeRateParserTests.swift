//
//  ExchangeRateParserTests.swift
//  CurrencyConverterTests
//
//  Created by Sarannya on 26/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class ExchangeRateParserTests : XCTestCase {
    
    func test_ParseEmptyCurrencyData(){
        
        let data = Data()
        
        let completion : ((Result<[ConvertedRate], ErrorResult>)->Void) = { response in
            switch response {
            case .success(_):
                XCTAssert(false, "Expected failure when no data")
            default:
                //test passes here
                break
            }
        }
        ParserHelper.parse(data: data, completion: completion)
    }
    
    
    func test_ParseJSONResponseData(){
        
        //Mock server response
        
        let jsonString = """
                            {
                                "success":true,
                                "timestamp":1558814285,
                                "base":"EUR",
                                "date":"2019-05-25",
                                "rates":{"AED":4.116371,"AFN":90.160103}
                            }
                         """
        
        let data = jsonString.data(using: .utf8)!
        
        let completion : ((Result<[ConvertedRate], ErrorResult>)->Void) = { response in
            switch response {
            case .success(let data):
                XCTAssertEqual(data.count, 2, "Expected 2 exchange rates from json ")
                
            case .failure(_):
                XCTAssert(false, "Expected failure when no data")
                break
            }
            
        }
        ParserHelper.parse(data: data, completion: completion)
    }
    
}
