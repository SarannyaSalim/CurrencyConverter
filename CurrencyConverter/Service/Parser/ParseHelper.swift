//
//  ParseHelper.swift
//  CurrencyConverter
//
//  Created by Sarannya on 25/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation

protocol Parceable {
    static func parseObject(dictionary: [String: AnyObject]) -> Result<Self, ErrorResult>
}



final class ParserHelper {
    
    static func parse(data: Data, completion : (Result<[ConvertedRate], ErrorResult>) -> Void)
    {
        let decoder = JSONDecoder()
        do{
            let rateDict = try decoder.decode(ExchangeRate.self, from: data)
            
            UserDefaults.standard.set(rateDict.date, forKey: "lastUpdatedDate")
            
            var finalRates : [ConvertedRate] = rateDict.rates
            finalRates.sort(by: <)
            completion(Result.success(finalRates))
            
        }catch{
            completion(Result.failure(ErrorResult.parser(string: error.localizedDescription)))
        }
    }
    
}
