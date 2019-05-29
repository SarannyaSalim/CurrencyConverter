//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Sarannya on 25/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation

struct ExchangeRate : Codable {
    let base : String
    let date : String
    let rates : [ConvertedRate]
    
    enum CodingKeys : String, CodingKey{
        case base
        case date
        case rates
    }
    
    init(from decoder : Decoder) throws{
        let values =  try decoder.container(keyedBy: CodingKeys.self)
        base = try values.decode(String.self, forKey: .base)
        date = try values.decode(String.self, forKey: .date)
        let additionalInfo = try values.decode([String:Double].self, forKey: .rates)
//        print(additionalInfo)
        rates = additionalInfo.map({ ConvertedRate(currencyName: $0.key, rate: $0.value) })
    }
}


struct ConvertedRate : Codable, Comparable{
    
    let currencyName : String
    let rate : Double

    static func < (lhs: ConvertedRate, rhs: ConvertedRate) -> Bool {
        return lhs.currencyName < rhs.currencyName
    }
}
