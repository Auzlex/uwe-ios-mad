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
// USE THIS SO SAVE TIME https://app.quicktype.io/ <- creates structs from json to decoables

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

public struct price_history: Decodable {
    let symbol: String
    let priceChange: String
    let priceChangePercent: String
    let weightedAvgPrice: String
    let prevClosePrice: String
    let lastPrice: String
    let lastQty: String
    let bidPrice: String
    let bidQty: String
    let askPrice: String
    let askQty: String
    let openPrice: String
    let highPrice: String
    let lowPrice: String
    let volume: String
    let quoteVolume: String
    let openTime: Int
    let closeTime: Int
    let firstId: Int
    let lastId: Int
    let count: Int
}

//


// MARK: - CoinMarketCapData
public struct CoinMarketCapData: Codable {
    let status: Status
    let data: [String: Datum]
}

// MARK: - Platform
struct Platform: Codable {
    let id: Int
    let name, symbol, slug, tokenAddress: String

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug
        case tokenAddress = "token_address"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let name, symbol, slug: String
    let numMarketPairs: Int
    let dateAdded: String
    let tags: [String]
    let maxSupply: Int?
    let circulatingSupply, totalSupply: Double
    let isActive: Int
    let platform: Platform?
    let cmcRank, isFiat: Int
    let selfReportedCirculatingSupply, selfReportedMarketCap: Double?
    let lastUpdated: String
    let quote: Quote

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug
        case numMarketPairs = "num_market_pairs"
        case dateAdded = "date_added"
        case tags
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case isActive = "is_active"
        case platform
        case cmcRank = "cmc_rank"
        case isFiat = "is_fiat"
        case selfReportedCirculatingSupply = "self_reported_circulating_supply"
        case selfReportedMarketCap = "self_reported_market_cap"
        case lastUpdated = "last_updated"
        case quote
    }
}

// MARK: - Quote
struct Quote: Codable {
    let usd: Usd

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// MARK: - Usd
struct Usd: Codable {
    let price, volume24H, volumeChange24H, percentChange1H: Double
    let percentChange24H, percentChange7D, percentChange30D, percentChange60D: Double
    let percentChange90D, marketCap, marketCapDominance, fullyDilutedMarketCap: Double
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume_24h"
        case volumeChange24H = "volume_change_24h"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case percentChange30D = "percent_change_30d"
        case percentChange60D = "percent_change_60d"
        case percentChange90D = "percent_change_90d"
        case marketCap = "market_cap"
        case marketCapDominance = "market_cap_dominance"
        case fullyDilutedMarketCap = "fully_diluted_market_cap"
        case lastUpdated = "last_updated"
    }
}

// MARK: - Status
struct Status: Codable {
    let timestamp: String
    let errorCode: Int
    let errorMessage: String?
    let elapsed, creditCount: Int
    let notice: String?

    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
        case notice
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

//    public var hashValue: Int {
//        return 0
//    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


//public struct status: Decodable {
//    var timestamp: String?
//    var error_code: Int?
//    var error_message: String?
//    var elapsed: Int?
//    var credit_count: Int?
//    var notice: String?
//}
//
//// MARK: - Quote
//struct Quote: Codable {
//    let usd: Usd
//
//    enum CodingKeys: String, CodingKey {
//        case usd = "USD"
//    }
//}
//
//// MARK: - Usd
//struct Usd: Codable {
//    let price, volume24H, volumeChange24H, percentChange1H: Double
//    let percentChange24H, percentChange7D, percentChange30D, percentChange60D: Double
//    let percentChange90D, marketCap, marketCapDominance, fullyDilutedMarketCap: Double
//    let lastUpdated: String
//
//    enum CodingKeys: String, CodingKey {
//        case price
//        case volume24H = "volume_24h"
//        case volumeChange24H = "volume_change_24h"
//        case percentChange1H = "percent_change_1h"
//        case percentChange24H = "percent_change_24h"
//        case percentChange7D = "percent_change_7d"
//        case percentChange30D = "percent_change_30d"
//        case percentChange60D = "percent_change_60d"
//        case percentChange90D = "percent_change_90d"
//        case marketCap = "market_cap"
//        case marketCapDominance = "market_cap_dominance"
//        case fullyDilutedMarketCap = "fully_diluted_market_cap"
//        case lastUpdated = "last_updated"
//    }
//}
//
//public struct data: Decodable {
//    var id: Int
//    var name: String
//    var symbol: String
//    var slug: String
//    var num_market_pairs: Int
//    var date_added: String
//    var tags: [String]
//    var max_supply: Int?
//    var circulating_supply: Double?
//    var total_supply: Double
//    var is_active: Int
//    var platform: String?
//    var cmc_rank: Int
//    var is_fiat: Int
//    var self_reported_circulating_supply: String?
//    var self_reported_market_cap: String?
//    var last_updated: String
//    let usd: Usd
//    // quote:
//    //     USD: {
//    //     price: 31838.08640698367,
//    //     volume_24h: 59521540343.03524,
//    //     volume_change_24h: -26.5707,
//    //     percent_change_1h: 0.35728428,
//    //     percent_change_24h: 1.48831783,
//    //     percent_change_7d: -18.3267915,
//    //     percent_change_30d: -23.45656086,
//    //     percent_change_60d: -18.83001491,
//    //     percent_change_90d: -28.66395829,
//    //     market_cap: 606098467121.1074,
//    //     market_cap_dominance: 42.6563,
//    //     fully_diluted_market_cap: 668599814546.66,
//    //     last_updated: "2022-05-11T11:01:00.000Z"
//    //     }
//    // }
//}
//
//public struct coin_market_cap_data: Decodable
//{
//    var data: Dictionary<String, data>
//    var status: status
//}
//
//public struct status2: Decodable {
//    var timestamp: String?
//    var error_code: Int?
//    var error_message: String?
//    var elapsed: Int?
//    var credit_count: Int?
//    var notice: String?
//    var total_count: Int?
//}
//
//public struct data2: Decodable {
//    var id: Int?
//    var name: String?
//    var symbol: String?
//    var slug: String?
//    var num_market_pairs: Int?
//    var date_added: String?
//    var tags: [String]
//    var max_supply: Int?
//    var circulating_supply: Double?
//    var total_supply: Double?
//    var cmc_rank: Int?
//    var self_reported_circulating_supply: String?
//    var self_reported_market_cap: String?
//    var last_updated: String?
//    // quote: {
//    //     USD: {
//    //     price: 31838.08640698367,
//    //     volume_24h: 59521540343.03524,
//    //     volume_change_24h: -26.5707,
//    //     percent_change_1h: 0.35728428,
//    //     percent_change_24h: 1.48831783,
//    //     percent_change_7d: -18.3267915,
//    //     percent_change_30d: -23.45656086,
//    //     percent_change_60d: -18.83001491,
//    //     percent_change_90d: -28.66395829,
//    //     market_cap: 606098467121.1074,
//    //     market_cap_dominance: 42.6563,
//    //     fully_diluted_market_cap: 668599814546.66,
//    //     last_updated: "2022-05-11T11:01:00.000Z"
//    //     }
//    // }
//    
//    public init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//        
//        id = try container.decode(Int.self)
//        name = try container.decode(String.self)
//        symbol = try container.decode(String.self)
//        slug = try container.decode(String.self)
//        num_market_pairs = try container.decode(Int.self)
//        date_added = try container.decode(String.self)
//        tags = try container.decode([String].self)
//        max_supply = try container.decode(Int.self)
//        circulating_supply = try container.decode(Double.self)
//        total_supply = try container.decode(Double.self)
//        cmc_rank = try container.decode(Int.self)
//        self_reported_circulating_supply = try container.decode(String.self)
//        self_reported_market_cap = try container.decode(String.self)
//        last_updated = try container.decode(String.self)
//    }
//}
//
//public struct coin_market_cap_data_dict: Decodable
//{
//    var data: [data2]
//    var status: status2
//}

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
    
    public func get24hourPriceHistory(symbol: String, completion: @escaping (price_history)->()) async {
        
        // this web request will fetch the 24 hour price history
        let url = URL(string: "https://api.binance.com/api/v1/ticker/24hr?symbol=\(symbol.uppercased())")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                //let json = try JSONSerialization.jsonObject(with: data, options: [])

                // attempt to decode price history summary
                let price_history_summary = try JSONDecoder()
                    .decode(price_history.self, from: data)

                print( "get24hourPriceHistory() -> price_history_summary", price_history_summary )

                completion( price_history_summary )

                //print(json)

//                 // create an empty double var
//                 var openPrice: Double = -1
//                 var lastPrice: Double = -1
//                 if let dictionary = json as? [String: Any] {

//                     for (key, value) in dictionary {
//                         // access all key / value pairs in dictionary
//                         //print(key, value)
                        
// //                        // if the key is "price" then set the price to the value as double
// //                        if key == "priceChangePercent" {
// //                            // convert price value from str to double
// //                            price_change = Double(value as! String) ?? 0.0
// //                            print("priceChangePercent:", price_change)
// //                            break
// //                        }
                        
//                         if key == "openPrice"
//                         {
//                             openPrice = Double(value as! String) ?? 0.0
//                             print("openPrice:", openPrice)
//                         }
                        
//                         if key == "lastPrice"
//                         {
//                             lastPrice = Double(value as! String) ?? 0.0
//                             print("lastPrice:", lastPrice)
//                         }
                        
                        
                        
//                     }
//                 }
                
//                 completion([ openPrice, lastPrice ])

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
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                
                let k_data = try JSONDecoder()
                    .decode([Kline_data].self, from: data)

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
        
    // fetch top coins from coin market cap
    public func fetch_coinmarket_cap_data(symbol: String, completion: @escaping (CoinMarketCapData)->() ) async {

        // ?CMC_PRO_API_KEY=07ed2739-4bcb-4806-83ae-948f1ce01ae9&
        let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?CMC_PRO_API_KEY=07ed2739-4bcb-4806-83ae-948f1ce01ae9&symbol=\(symbol.uppercased())")!
//        var request = URLRequest(url:url)
//        request.allHTTPHeaderFields = [
//            "CMC_PRO_API_KEY": "07ed2739-4bcb-4806-83ae-948f1ce01ae9"
//        ]
//        request.setValue("application/png", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                // let json = try JSONSerialization.jsonObject(with: data, options: [])
                // print(json)

               let cmc_data = try JSONDecoder()
                   .decode(CoinMarketCapData.self, from: data)

                //print(cmc_data)
            
                completion(cmc_data)

            } catch {
                print(error)
            }
        }
        task.resume()

    }
    
    public func fetch_crypto_news(completion: @escaping (CryptoNews)->()) async {

        
            // ?CMC_PRO_API_KEY=07ed2739-4bcb-4806-83ae-948f1ce01ae9&
            let url = URL(string: "https://newsapi.org/v2/everything?q=crypto&apiKey=94ba1e8999df4532816352e87dec286b")!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                do {
       
                   let news_data = try JSONDecoder()
                       .decode(CryptoNews.self, from: data)

                    //print(cmc_data)

                    completion(news_data)

                } catch {
                    print(error)
                }
            }
            task.resume()

    }
    
}

// MARK: - CoinMarketCapData
public struct CryptoNews: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    //let id = UUID()
    let source: Source
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}

