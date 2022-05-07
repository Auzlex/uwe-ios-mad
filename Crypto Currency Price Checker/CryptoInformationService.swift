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
import SwiftUICharts
import SwiftUI

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
                //print(json)

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

    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    //https://stackoverflow.com/questions/49147475/decoding-a-json-without-keys-in-swift-4 THANK YOU SO MUCH
    struct Kline_data: Codable {
        var open_time:Int
        var open:String
        var high:String
        var low:String
        var close:String
        var volume:String
        var close_time: Int
        var quote_asset_volume:String
        var number_of_trades:Int
        var taker_buy_base_asset_volume:String
        var taker_buy_quote_asset_volume:String
        var ignore:String
        
        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            open_time = try container.decode(Int.self)
            open = try container.decode(String.self)
            high = try container.decode(String.self)
            low = try container.decode(String.self)
            close = try container.decode(String.self)
            volume = try container.decode(String.self)
            close_time = try container.decode(Int.self)
            quote_asset_volume = try container.decode(String.self)
            number_of_trades = try container.decode(Int.self)
            taker_buy_base_asset_volume = try container.decode(String.self)
            taker_buy_quote_asset_volume = try container.decode(String.self)
            ignore = try container.decode(String.self)
        }
    }

    public struct Kline_data_simple: Codable {
        var open_time:Int
        var open:String
        var high:String
        var low:String
        var close:String
        var volume:String
        var close_time: Int
        var quote_asset_volume:String
        var number_of_trades:Int
        var taker_buy_base_asset_volume:String
        var taker_buy_quote_asset_volume:String
        var ignore:String
        
    }
    
    // get the historical kline data
    public func get_historic_kline_data(symbolName: String, interval: String, limit: String, completion: @escaping (LineChartData)->() ) async {

        let url = URL(string: "https://api.binance.com/api/v3/klines?symbol=\(symbolName.uppercased())&interval=\(interval)&limit=\(limit)")!
//        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                
                let k_data = try JSONDecoder()
                    .decode([Kline_data].self, from: data)

//                // convert k_data into Kline_data_simple
//                var k_data_simple = [Kline_data_simple]()
//                for k in k_data {
//                    k_data_simple.append(Kline_data_simple(open_time: k.open_time, open: k.open, high: k.high, low: k.low, close: k.close, volume: k.volume, close_time: k.close_time, quote_asset_volume: k.quote_asset_volume, number_of_trades: k.number_of_trades, taker_buy_base_asset_volume: k.taker_buy_base_asset_volume, taker_buy_quote_asset_volume: k.taker_buy_quote_asset_volume, ignore: k.ignore))
//                }

                var data_points = [LineChartDataPoint]()
                var i = 0;
                var highest = 0.0;
                var lowest = Double.greatestFiniteMagnitude;
                for kline_data in k_data {
                    i = i + 1;
//                    print("kline_data -> :", kline_data)
                    
                    if (Double(kline_data.close)! > highest) {
                        highest = Double(kline_data.close)!
                    }
                    
                    if (Double(kline_data.close)! < lowest) {
                        lowest = Double(kline_data.close)!
                    }
                    
                    data_points.append(LineChartDataPoint(value: Double(kline_data.close)!, xAxisLabel: "\(i)", description: "Close Price"))
                }
            
                
                func kline_data() -> LineChartData {
                    let data = LineDataSet(dataPoints: data_points,
                    legendTitle: "Close Price",
                    pointStyle: PointStyle(),
                    style: LineStyle(lineColour: ColourStyle(colours: [Color.red.opacity(0.50),
                                                                       Color.red.opacity(0.00)],
                                                             startPoint: .top,
                                                             endPoint: .bottom),
                                     lineType: .line))
                    
                    return LineChartData(dataSets: data,
                                         metadata: ChartMetadata(title: "\(interval) Chart".uppercased(), subtitle: "Price History".uppercased()),
                                         //xAxisLabels: ["Monday", "Thursday", "Sunday"],
                                         chartStyle: LineChartStyle(infoBoxPlacement: .header,
                                                                    markerType: .full(attachment: .point),
                                                                    //xAxisLabelsFrom: .chartData(rotation: .degrees(0)),
                                                                    baseline: .minimumWithMaximum(of: lowest*0.95))) // 5000
                }
                

                completion(kline_data())


                    //.elementss
                //print("K_DATA: ",k_data.first)
                

                //completion(k_data)

            } catch {
                print(error)
            }
        }
        task.resume()

    }
    
}

