//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

/// Handler block
typealias APIResponse = ((_ response: Any?, _ error: Error?) -> Void)

/// Error Handler
enum CoinAPIError: Error {
    case invalidRequest
    case invalidJSON
    case unknown
}

/// Exchange Rates Functions
protocol ExchangeRatesProtocol {
    func exchangeRatesBy(assetId base: String, idQuote: String, time: Int, completionHandler: @escaping APIResponse)
}

//MARK: - CoinManager
struct CoinAPI {
    
  let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
  private (set) var apiKey = "52D5500D-31D5-4098-A693-FC799E5B6800"
  
  let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

      
  /// Perform URLRequest and return data based on the API response.
  private func perform(request _request: URLRequest, completionHandler: @escaping APIResponse) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: _request) { (data, response, error) in
        
      guard let responseData = data else {
        completionHandler(nil, CoinAPIError.unknown)
        return
      }
        
      do {
        let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
        completionHandler(jsonResponse, nil)
      } catch {
        completionHandler(nil, CoinAPIError.invalidJSON)
      }
    }
    
    task.resume()
  }
}

extension CoinAPI: ExchangeRatesProtocol {
  
  func exchangeRatesBy(assetId base: String, idQuote: String, time: Int, completionHandler: @escaping APIResponse) {
    
    /// build URI string
    var requestResource = "/v1/exchangerate/\(base)/\(idQuote)"
    if time > 0 {
      requestResource = "/v1/exchangerate/\(base)/\(idQuote)?time=\(time)"
    }
    
    guard let requestUrl = URL(string: baseURL.appending(requestResource)) else {
      completionHandler(nil, CoinAPIError.invalidRequest)
      return
    }
    
    /// Build request
    let request = NSMutableURLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 100)
    request.httpMethod = "GET"
    request.addValue(self.apiKey, forHTTPHeaderField: apiKey)
    
    /// Perform request
    perform(request: request as URLRequest, completionHandler: completionHandler)
  }
}
