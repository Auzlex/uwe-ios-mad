//
//  CryptoInformationService.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 04/03/2022.
//


// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// TODO: Check this out mate https://betterprogramming.pub/build-a-bitcoin-price-ticker-in-swiftui-b16d9ca566a8, remember to remove this crap OKAY!!!!!!!!!
// https://github.com/binance/binance-spot-api-docs/blob/master/rest-api.md
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!
// remember to remove this crap OKAY!!!!!!!!!

import Foundation
import CoreFoundation

struct APIResponse: Decodable {
    let timezone: String
    let serverTime: Int
    let symbols: [APISymbol]
}

struct APISymbol: Decodable, Hashable {
    let symbol: String
    let status: String
    let baseAsset: String
    let baseAssetPrecision: Int
    let quoteAsset: String
    let quotePrecision: Int
    let quoteAssetPrecision: Int
    let baseCommissionPrecision: Int
    let quoteCommissionPrecision: Int
}


// this struct will contain all the exchange information on open of the app
public struct ExchangeInformation {
    
    let timezone: String // stores the time zone of fetched information
    let serverTime: Int // server time of request
    let symbols: Array<APISymbol>// an array of available tradeable symbols from binance.com
    
    init(response: APIResponse)
    {
        timezone = response.timezone
        serverTime = response.serverTime
        //symbols = response.symbols
        // array filter
        //symbols = response.symbols.filter { $0.symbol.contains("USDT") } // NOTE: removes all other cyrpto assets that don't contain USD
        symbols = response.symbols.filter { $0.symbol.suffix(4).contains("USDT") } // NOTE: removes all other cyrpto assets that don't end with USDT
        
    }
    
}

public final class CryptoInformationService: NSObject {
    private let API_KEY = ""
    private let SECRET_KEY = ""
    
    private var completionHandler: ((ExchangeInformation) -> Void)?
    
    public override init() {
        super.init()
    }
    
//    public func getUpdatedExchangeInformation(_ completionHandler: @escaping((ExchangeInformation) -> Void) )
//    {
//        self.completionHandler = completionHandler
//        makeDataRequest()
//    }
//    
//    public func makeDataRequest()
//    {
//        // this url fetches exchange information for crypto currencies
//        guard let exchange_url_format = "https://api.binance.com/api/v3/exchangeInfo"
//            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        else { return }
//    
//        guard let url = URL(string: exchange_url_format) else { return }
//    
//        URLSession.shared.dataTask(with: url) { data, reponse, error in
//            guard error == nil, let data = data else { return }
//            
//            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
//                self.completionHandler?(ExchangeInformation(response: response))
//            }
//        }.resume()
//    }
    
    public func getUpdatedExchangeInformationAsync(_ completionHandler: @escaping((ExchangeInformation) -> Void) ) async
    {
        self.completionHandler = completionHandler
        try! await makeDataRequestAsync()
    }
    
    func makeDataRequestAsync() async throws {
        guard let url = URL(string: "https://api.binance.com/api/v3/exchangeInfo") else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                self.completionHandler?(ExchangeInformation(response: response))
            }
        //print("Async decodedFood", response)
    }
    
}

