//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Sarannya on 25/05/19.
//  Copyright © 2019 Sarannya. All rights reserved.
//

import Foundation

enum ValueType {
    case Base
    case Target
}

class ConverterViewModel {
    
    weak var service : DataFetchServiceProtocol?
    weak var dataSource : GenericDataSource<ConvertedRate>?
    
    var selectedBaseCurrency : String?
    var selectedTargetCurrency : String?
    
    var errorResult : ((ErrorResult?)->Void)?
    var successResult : (()->Void)?

    
    init(dataSource : GenericDataSource<ConvertedRate>) {
        self.dataSource = dataSource
        self.selectedBaseCurrency = "EUR"
        self.selectedTargetCurrency = "USD"
        self.service = ServerDataFetchService.shared
        //Service set up call
        setFetchService()
    }
    
    
    
    //MARK:- set up service from SERVER or LOCAL
    // // //
    func setFetchService(){
        
        //if no network connectivity : serve from LOCAL
        if let reachability = Reachability(), !reachability.isReachable{
            
            //local file availability check
            setLocalfetchService()
        }
        
        guard let lastDate = UserDefaults.standard.value(forKey: "lastUpdatedDate") else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateToday = (dateFormatter.string(from: Date()))
        
        //fetch from server only once in a day . check if local data available for today
        if lastDate as! String == dateToday {
            
            //service to load CACHED LOCAL data
            setLocalfetchService()
        }
        
    }
    
    func setServiceExplicitly(service : DataFetchServiceProtocol?){
        self.service = service
    }
    
    func setLocalfetchService(){
        
        //JSON file path
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let filePathInDocuments = documentDirectoryPath.appendingPathComponent("ExchangeRates.json")
        
        //check if file available
        if FileManager().fileExists(atPath: filePathInDocuments.path){
            
            // from LOCAL
           setServiceExplicitly(service: LocalDataFetchService.shared)

        }else{
            
            //from SERVER
            setServiceExplicitly(service: ServerDataFetchService.shared)
        }
    }
    
    
    //call to data fetch service
    func fetchData(completion : @escaping (()->Void)) {
        
        guard let service = service else {
            errorResult?(ErrorResult.custom(string: "service missing"))
            return
        }
        service.fetchExchangeRates() { (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let receivedData):
                            self.dataSource?.data = receivedData
                            completion()
                    
                case .failure(let error):
                            self.errorResult?(error)
                }
            }
        }
    }
    
    
//MARK:- Data manipulations and Calculations
    
    // change base currency when user selects
    //
    func setNewBaseCurrency(code : String){
        self.selectedBaseCurrency = code
    }
    
    // change base currency when user selects
    //
    func setNewTargetCurrency(code : String){
        self.selectedTargetCurrency = code
    }
    
    
    //called from picker view delegate to set the currency codes in rows
    //
    func currencyCode(at index : Int) -> String{
        guard let currencyList = self.dataSource?.data else {
            fatalError()
        }
        let code = currencyList[index].currencyName
        return code
    }
    
    //calculate the Target exchange rate
    //
    func calculateTargetRate(for baseAmount : String) -> String{
        
        let baseValueInDouble : Double = (baseAmount as NSString).doubleValue
        
        let baseValueToday : Double = valueToday(for: .Base) //value of selected base
        let targetValueToday : Double = valueToday(for: .Target) //value of selected target
        
        let targetFinal : Double = (targetValueToday / baseValueToday) * baseValueInDouble
        return (String(format: "%.2f", targetFinal))
        
    }
    
    //returns the current value of a Currency w.r.t EUR (default base)
    //
    func valueToday(for type : ValueType) -> Double{
        
        let list = self.dataSource?.data
        
        let currencyType : String?
        switch type {
        case .Base:
            currencyType = self.selectedBaseCurrency
        default:
            currencyType = self.selectedTargetCurrency
        }
        
        if let index = list?.firstIndex(where: {$0.currencyName == currencyType}){
            
            let item = list![index]
            return item.rate
        }
        return 0
    }
    
    
    //scrolls the picker to default index on launch
    //
    func defaultIndex() -> Int {
        let list = self.dataSource?.data
        if let index = list?.firstIndex(where: {$0.currencyName == "USD"}){
            return index
        }
        return 0
    }
}
