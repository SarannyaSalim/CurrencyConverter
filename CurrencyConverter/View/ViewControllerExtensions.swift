//
//  ViewControllerExtensions.swift
//  CurrencyConverter
//
//  Created by Sarannya on 26/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Extensions

//MARK:- UIPickerView delegate methods
extension ViewController : UIPickerViewDelegate{
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let currencyCode = viewModel.currencyCode(at: row)
        switch type {
            
        case .Base:
            baseCurrencyCodeLabel.text = currencyCode
            viewModel.setNewBaseCurrency(code: currencyCode)
            
        case .Target:
            targetCurrencyCodeLabel.text = currencyCode
            viewModel.setNewTargetCurrency(code: currencyCode)
        }
        
        // call to view model to fetch and caculate values
        updateTarget()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.currencyCode(at: row)
    }
    
}

//MARK:- Textfield delegate methods / Keyboard visibility
extension ViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currencyPicker.isHidden = true
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        currencyPicker.isHidden = false
    }
    
}
