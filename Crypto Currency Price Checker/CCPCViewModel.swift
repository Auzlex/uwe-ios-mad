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
    }
    
    public func refresh() async
    {
        await cryptoInformationService.getUpdatedExchangeInformationAsync{
            exchangeInfo in DispatchQueue.main.async {
                self.symbols = exchangeInfo.symbols
                // print the count of symbols
                print("count of symbols: \(self.symbols.count)")
                
            }
        }
    }

    // this function is called when we want to async await fetch price from binance api
    public func fetchprice_for_symbol(symbolName: String, completion: @escaping (Double)->() ) async {
        
        // this async function is called on the crypto information service class which takes in a SYMBOL NAME
        // this is in binance standard so for example symbol name needs to be BTCUSDT
        // returns prices fetched in dispatchque fetch price we then pass this back through
        // another completion handler
        await cryptoInformationService.getPriceForSymbol(symbol: symbolName) {
            
            fetched_price in DispatchQueue.main.async {

                print("fetchprice_for_symbol -> cryptoInformationService.getPriceForSymbol: \(fetched_price)")
                completion(fetched_price)
                
            }
        }

    }
    
}
