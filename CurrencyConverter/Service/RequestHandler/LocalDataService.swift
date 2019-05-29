//
//  LocalDataService.swift
//  CurrencyConverter
//
//  Created by Sarannya on 25/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation

final class LocalDataFetchService : DataFetchServiceProtocol{
    
    static let shared = LocalDataFetchService()
    var filePathInDocuments : URL?

    
    func fetchExchangeRates(_ completion: @escaping ((Result<[ConvertedRate], ErrorResult>) -> Void)) {
        
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
         filePathInDocuments = documentDirectoryPath.appendingPathComponent("ExchangeRates.json")
        do{
            let data = try Data(contentsOf: filePathInDocuments!)
            
            ParserHelper.parse(data: data, completion: completion)
        }catch{
//            print(error)
            completion(Result.failure(.custom(string: "\(error.localizedDescription)")))
        }
    }
    
}
