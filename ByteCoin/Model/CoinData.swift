//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Riley Lai on 2022/5/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
  let exchangeRate: Double
  let chosenFiat: String
  
  enum CodingKeys: String, CodingKey {
    case exchangeRate = "rate"
    case chosenFiat = "asset_id_quote"
  }
}
