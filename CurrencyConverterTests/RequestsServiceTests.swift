//
//  RequestsServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Sarannya on 26/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class RequestServiceTests : XCTestCase{
    
    var requestService : RequestService!
    var session = MockUrlSession()
    typealias completeClosure = (Result<Data, ErrorResult>)->Void
    let url = "https://mock.com"
    
    override func setUp() {
        super.setUp()
        
        requestService = RequestService(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        
        requestService = nil
    }
    
    
    func test_RequestDataWithURL(){
        
        _ = requestService.requestDataFromServer(urlstring: url) { _ in
            
            //success
        }
        
        // if the urls are the same before and after
        XCTAssert(session.lastURL == URL(string: url))
        
    }
    
    func test_TaskResumeCalled() {
        
        let dataTask = MockUrlSessionTask()
        session.nextDataTask = dataTask
        
        _ = requestService.requestDataFromServer(urlstring: url) { _ in
            
            //success
        }
        
        //the variable is set to TRUE when resumeTask() is called for the mock request
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    
    func test_RequestShouldReturnData() {
        
        let expectedData = "{}".data(using: .utf8)
        
        session.nextData = expectedData
        
        var actualData: Data?
        
        _ = requestService.requestDataFromServer(urlstring: url) { response in
            
            switch response {
            case .success(let data):
                actualData = data
                break;
            case .failure(_):
                break
            }
        }
        
        XCTAssertNotNil(actualData)
    }
    
}






//MARK:- Mock Objects


class MockUrlSession : URLSessionProtocol{
    
    var nextDataTask = MockUrlSessionTask()
    var nextData: Data?
    var nextError: Error?
    private (set) var lastURL: URL?
    
    func mockSuccessURLResponse(request: URLRequest)->URLResponse{
        return URLResponse(url: request.url!, mimeType: "", expectedContentLength: 50, textEncodingName: "")
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol {
        
        lastURL = request.url
        completionHandler(nextData, mockSuccessURLResponse(request: request), nextError)
        return nextDataTask
    }
}


class MockUrlSessionTask : URLSessionTaskProtocol {
    
    private (set) var resumeWasCalled = false
    
    func resumeTask (){
        
        resumeWasCalled = true
    }
}
