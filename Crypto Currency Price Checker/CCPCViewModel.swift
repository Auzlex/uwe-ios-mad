//
//  CCPCViewModel.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 11/03/2022.
//

import Foundation
import SwiftUI

private let defaultIcon = "❓"

public class CCPCViewModel : ObservableObject {
    //@Published var symbol: String = "---"
    //@Published var symbolIcon: String = defaultIcon
    //@Published var price: String = "£--.--"
    
    //@Published var exchangeInformation: [ExchangeInformation]()
    @Published var symbols = [APISymbol]()
    
    public let cryptoInformationService: CryptoInformationService
    
    public init( cryptoInformationService: CryptoInformationService )
    {
        self.cryptoInformationService = cryptoInformationService
        //symbols = self.cryptoInformationService.
    }
    
    
    
//    public func refresh()
//    {
//        cryptoInformationService.getUpdatedExchangeInformation{
//            exchangeInfo in DispatchQueue.main.async {
//                self.symbols = exchangeInfo.symbols
//            }
//        }
//
//    }
    
    public func refresh() async
    {
        //Task{
            await cryptoInformationService.getUpdatedExchangeInformationAsync{
                exchangeInfo in DispatchQueue.main.async {
                    self.symbols = exchangeInfo.symbols
                    // print the count of symbols
                    print("count of symbols: \(self.symbols.count)")
                    
                }
            }
            
        //}
        
    }

    // this function is called when we want to async await fetch price from binance api
    public func fetchprice_for_symbol(symbolName: String) -> Double {
        
        // await cryptoInformationService.getPriceForSymbol(symbol: symbolName) {
        //     price in DispatchQueue.main.async {
        //         print("price: \(price)")
        //         return price
        //     }
        // }
        
        // invoke async function cryptoInformationService.getPriceForSymbol with symbolName

        return 0

    }
    
}
