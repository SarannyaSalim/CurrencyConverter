//
//  DataFetchService.swift
//  AdvancedSwift
//
//  Created by Sarannya on 10/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation

protocol DataFetchServiceProtocol : class{
    func fetchExchangeRates(_ completion: @escaping ((Result<[ConvertedRate], ErrorResult>) -> Void))
}


final class ServerDataFetchService : DataFetchServiceProtocol{

    static let shared = ServerDataFetchService()
    
    var task : URLSessionTask?
    
    func fetchExchangeRates(_ completion: @escaping ((Result<[ConvertedRate], ErrorResult>) -> Void)) {
        
        let key = "1688167461cde4b3ca943c79d9ef9973"
        let endpoint = "http://data.fixer.io/api/latest?access_key=\(key)"
        
        self.cancelPreviousTask()
        
        task = RequestService(session: URLSession(configuration: .default)).requestDataFromServer(urlstring: endpoint, completion: { (result) in
            switch result {
                
                    case .success(let data):
                        ParserHelper.parse(data: data, completion: completion)
                        self.saveResponseToDevice(data: data)
                
                    case .failure(let error):
                        completion(.failure(.network(string: "Network error \(error.localizedDescription)")))
            }
        })
        
    }
    
    func cancelPreviousTask(){
        if let task = task{
            task.cancel()
        }
        task = nil
    }
    
    
    //MARK:- Local Saving for offline use
    func saveResponseToDevice(data : Data){
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let filePathInDocuments = documentDirectoryPath.appendingPathComponent("ExchangeRates.json")
        
        do{
            try data.write(to: filePathInDocuments)
        }catch{
            print(error.localizedDescription)
        }
    }
}
