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
// get price history 24h https://api.binance.com/api/v1/ticker/24hr?symbol=BTCUSDT
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
    
    public func getUpdatedExchangeInformationAsync(_ completionHandler: @escaping((ExchangeInformation) -> Void) ) async
    {
        self.completionHandler = completionHandler
        /*
         Thread 5: Fatal error: 'try!' expression unexpectedly raised an error: Error Domain=NSURLErrorDomain Code=-1003 "A server with the specified hostname could not be found." UserInfo={_kCFStreamErrorCodeKey=8, NSUnderlyingError=0x6000015edbc0 {Error Domain=kCFErrorDomainCFNetwork Code=-1003 "(null)" UserInfo={_NSURLErrorNWPathKey=satisfied (Path is satisfied), interface: en1, _kCFStreamErrorCodeKey=8, _kCFStreamErrorDomainKey=12}}, _NSURLErrorFailingURLSessionTaskErrorKey=LocalDataTask <8C1CCCF0-C979-4FF3-A4EF-6809DED2
         */
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

    public func getPriceForSymbol(symbol: String, completion: @escaping (Double)->() ) async {

        let url = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=\(symbol.uppercased())")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)

                // create an empty double var
                var price: Double = -1
                if let dictionary = json as? [String: Any] {

                    for (key, value) in dictionary {
                        // access all key / value pairs in dictionary
                        //print(key, value)
                        
                        // if the key is "price" then set the price to the value as double
                        if key == "price" {
                            // convert price value from str to double
                            price = Double(value as! String) ?? 0.0
                            //print("getPriceForSymbol:", price)
                            break
                        }
                        
                    }
                }
                
                completion(price)

            } catch {
                print(error)
            }
        }
        task.resume()

    }
    
    public func get24hourPriceHistory(symbol: String, completion: @escaping ([Double])->()) async {
        
        // this web request will fetch the 24 hour price history
        let url = URL(string: "https://api.binance.com/api/v1/ticker/24hr?symbol=\(symbol.uppercased())")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)

                // create an empty double var
                var openPrice: Double = -1
                var lastPrice: Double = -1
                if let dictionary = json as? [String: Any] {

                    for (key, value) in dictionary {
                        // access all key / value pairs in dictionary
                        //print(key, value)
                        
//                        // if the key is "price" then set the price to the value as double
//                        if key == "priceChangePercent" {
//                            // convert price value from str to double
//                            price_change = Double(value as! String) ?? 0.0
//                            print("priceChangePercent:", price_change)
//                            break
//                        }
                        
                        if key == "openPrice"
                        {
                            openPrice = Double(value as! String) ?? 0.0
                            print("openPrice:", openPrice)
                        }
                        
                        if key == "lastPrice"
                        {
                            lastPrice = Double(value as! String) ?? 0.0
                            print("lastPrice:", lastPrice)
                        }
                        
                        
                        
                    }
                }
                
                completion([ openPrice, lastPrice ])

            } catch {
                print(error)
            }
        }
        task.resume()
        
    }

    // get the historical kline data
    public func get_historic_kline_data(symbolName: String, interval: String, limit: String, completion: @escaping (Double)->() ) async {

        let url = URL(string: "https://api.binance.com/api/v3/klines?symbol=\(symbolName.uppercased())&interval=\(interval)&limit=\(limit)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
                completion(0)

            } catch {
                print(error)
            }
        }
        task.resume()

    }
    
}

