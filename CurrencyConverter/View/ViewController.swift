//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Sarannya on 25/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import UIKit
//1688167461cde4b3ca943c79d9ef9973

class ViewController: UIViewController {
    
    var type = ValueType.Base
    
    let source = CurrencyPickerDataSource()
    lazy var viewModel : ConverterViewModel = {
        
        //viemodel also initializes Service to fetch data in init()
        let vm = ConverterViewModel(dataSource: source)
        return vm
    }()
    
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var baseBtn: UIButton!
    @IBOutlet weak var targetBtn: UIButton!
    @IBOutlet weak var basValueText: UITextField!
    @IBOutlet weak var targetValue: UILabel!
    @IBOutlet weak var baseCurrencyCodeLabel: UILabel!
    @IBOutlet weak var targetCurrencyCodeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currencyPicker.delegate = self
        currencyPicker.dataSource = source
        basValueText.keyboardType = .decimalPad
        basValueText.delegate = self
        
        //notify for error from viewModel
        
        self.viewModel.errorResult = { [weak self] _ in
            // display error ?
            self?.showAlertOnError()
        }
        
//        Fetch Exchange rates for today
        self.viewModel.fetchData { [weak self] in
            self?.currencyPicker.reloadAllComponents()
            self?.setDefaultSetup()
        }
    }

//MARK:- IBActions
    @IBAction func baseBtnPressed(_ sender: Any) {
        type = ValueType.Base
        basValueText.backgroundColor = UIColor(red: 229/255, green: 204/255, blue: 1, alpha: 1)
        targetValue.backgroundColor = .white
        currencyPicker.isHidden = false

    }
    
    @IBAction func targetBtnPressed(_ sender: Any) {
        type = ValueType.Target
        targetValue.backgroundColor = UIColor(red: 229/255, green: 204/255, blue: 1, alpha: 1)
        basValueText.backgroundColor = .white
        currencyPicker.isHidden = false

    }
    
    @IBAction func baseValueChanged(_ sender: UITextField) {
        updateTarget()
    }
    
    
    // MARK:- Update Target Label Value
    
    func updateTarget(){
        let value = viewModel.calculateTargetRate(for: basValueText.text!)
        targetValue.text = value
    }
    
    func  setDefaultSetup(){
        
        self.hideKeyboard()

        basValueText.text = "1"
        targetValue.text = viewModel.calculateTargetRate(for: "1")
        self.currencyPicker.selectRow(self.viewModel.defaultIndex(), inComponent: 0, animated: false)
    }
    
    //MARK:- Show Alert
    
    func showAlertOnError(){
        let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}


