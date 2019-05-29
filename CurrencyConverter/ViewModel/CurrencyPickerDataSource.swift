//
//  VCPickerViewDataSource.swift
//  CurrencyConverter
//
//  Created by Sarannya on 25/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource<T> : NSObject {
    var data : [T] = []
}

class CurrencyPickerDataSource : GenericDataSource<ConvertedRate>, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        print("currencies \(self.data.count)")
        return self.data.count
    }
    
}
