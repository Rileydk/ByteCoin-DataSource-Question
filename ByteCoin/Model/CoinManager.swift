//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Riley Lai on 2022/5/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
  func didUpdateExchange(_ coinManager: CoinManager, coinModel: CoinModel)
  func didFailWithError(_ coinManager: CoinManager, error: Error)
}

struct CoinManager {
  
  var delegate: CoinManagerDelegate?
    
  let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
  private (set) var apiKey = "52D5500D-31D5-4098-A693-FC799E5B6800"
  
  let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
  
  ///// fecthData
  func fetchExcahngeRatemByUSD() {
    performRequest(with: "\(baseURL)/USD")
  }
  
  func fetchExcahngeRate(by fiat: String) {
    let fullURLString = "\(baseURL)/\(fiat)"
    performRequest(with: fullURLString)
  }
  
  func performRequest(with urlString: String) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, res, error in
        if error != nil {
          delegate?.didFailWithError(self, error: error!)
          return
        }
        
        if let data = data {
          if let parsedData = parseJSON(data) {
            delegate?.didUpdateExchange(self, coinModel: parsedData)
          }
        }
        
      }
      
      task.resume()
    }

  }
  
  /// Parse JSON
  func parseJSON(_ exchangeRateData: Data) -> CoinModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(CoinData.self, from: exchangeRateData)
      let fiat = decodedData.chosenFiat
      let exchangeRate = decodedData.exchangeRate
      
      let coinModel = CoinModel(fiat: fiat, exchangeRate: exchangeRate)
      return coinModel
      
    } catch {
      delegate?.didFailWithError(self, error: error)
      return nil
    }
    
  }
}
