//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var fiatPickerOutlet: UIPickerView!
  @IBOutlet weak var exchangeRateLabel: UILabel!
  @IBOutlet weak var fiatCurrenyNameLabel: UILabel!
  
  let coinManager = CoinManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    fiatPickerOutlet.delegate = self
//    fiatPickerOutlet.dataSource = self
    
    coinManager.fetchExcahngeRatemByUSD()
  }
}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return coinManager.currencyArray.count
  }
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return coinManager.currencyArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let chosenFiat = coinManager.currencyArray[row]
    fiatCurrenyNameLabel.text = chosenFiat
    coinManager.fetchExcahngeRate(by: chosenFiat)
  }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
  func didUpdateExchange(_ coinManager: CoinManager, coinModel: CoinModel) {
    fiatCurrenyNameLabel.text = coinModel.fiat
    exchangeRateLabel.text = String(format: "%.2f", coinModel.exchangeRate)
  }
  
  func didFailWithError(_ coinManager: CoinManager, error: Error) {
    print(error)
  }
}

//// 設定Picker View，帶出法幣名稱資料，捲動時print出名稱
// 啟動時，從CoinAPI取回當前匯率資料，試著print出金額（美元計價）
// 捲動時再次從CoinAPI取回資料，並print出金額（美元計價）
// 使用捲動時選定的法幣來取回資料，並print出金額
// 用Delegate讓畫面和取回的金額連動
