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
    let rates : [String:Double]
}


struct ConvertedRate : Codable, Comparable{
    
    let currencyName : String
    let rate : Double

    
    static func < (lhs: ConvertedRate, rhs: ConvertedRate) -> Bool {
        return lhs.currencyName < rhs.currencyName
    }
}
