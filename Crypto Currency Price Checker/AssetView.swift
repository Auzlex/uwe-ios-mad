//
//  AssetView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 29/04/2022.
//

import Foundation
import SwiftUI
import SwiftUICharts

// removes trailing zeros
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}

/*
    AssetView is used by navigation link to view asset information that is passed into this view struct
*/
struct AssetView: View {

    @ObservedObject var viewModel: CCPCViewModel
    @State var symbolName: String = "" // the full name of the symbol
    @State var symbolPrecision: Int = 2 // default is round to 2 decimal places
    @State var symbolNameAlone: String = "" // the symbolname stand alone removing USDT
    @State var price: Double = 0 // stores price of currency
    @State var priceChange: [Double] = [ 0, 0 ] // stores price change data
    @State var price_percentage_hour_change: Double = 0 // stores percentage of price change
    @State var price_history: price_history?
    @State var asset_data: Datum?
    
    @State var interval: String = "1w" // interval
    @State var limit: String = "14" // interval
    
    @State var highest: Double = 0.0
    @State var lowest: Double = 0.0

    //@State var data = [ChartPoint]() // stores data for chart

    @State var isLoading: Bool = true // async loading variable for this view
    
    static func weekOfData() -> LineChartData {
        let data = LineDataSet(dataPoints: [
            LineChartDataPoint(value: 12000, xAxisLabel: "M", description: "Monday"),
            LineChartDataPoint(value: 13000, xAxisLabel: "T", description: "Tuesday"),
            LineChartDataPoint(value: 8000,  xAxisLabel: "W", description: "Wednesday"),
            LineChartDataPoint(value: 17500, xAxisLabel: "T", description: "Thursday"),
            LineChartDataPoint(value: 16000, xAxisLabel: "F", description: "Friday"),
            LineChartDataPoint(value: 11000, xAxisLabel: "S", description: "Saturday"),
            LineChartDataPoint(value: 9000,  xAxisLabel: "S", description: "Sunday")
        ],
        legendTitle: "Test One",
        pointStyle: PointStyle(),
        style: LineStyle(lineColour: ColourStyle(colours: [Color.red.opacity(0.50),
                                                           Color.red.opacity(0.00)],
                                                 startPoint: .top,
                                                 endPoint: .bottom),
                         lineType: .line))
        
        return LineChartData(dataSets: data,
                             metadata: ChartMetadata(title: "1H Price Change", subtitle: "24 Hour Price History"),
                             //xAxisLabels: ["Monday", "Thursday", "Sunday"],
                             chartStyle: LineChartStyle(infoBoxPlacement: .header,
                                                        markerType: .full(attachment: .point),
                                                        //xAxisLabelsFrom: .chartData(rotation: .degrees(0)),
                                                        baseline: .minimumWithMaximum(of: 0))) // 5000
    }
    
    @State var data : LineChartData = weekOfData()


    public func calculatePercentage( openPrice:Double, lastPrice:Double ) -> Double {
        return 0 + ( lastPrice - openPrice )/(openPrice)
    }
    
    init(symbolName: String, activeViewModel: CCPCViewModel)
    {
        self.symbolName = symbolName
        
        if let foundelement = activeViewModel.symbols.enumerated().first(where: {$0.element.symbol == symbolName}) {
            self.symbolPrecision = foundelement.element.quotePrecision

        } else {
           print("no symbol precision could have been found for this symbol")
        }
    
        self.symbolNameAlone = String(String(symbolName).dropLast(4))
        self.viewModel = activeViewModel
        //self.price_history =
    }

    var body: some View {

        ScrollView {
            // if is loading, show loading view
            if isLoading {
                LoadingView()
            }
            else {
                HStack{
                    AsyncImage(
                        url:URL(string:"https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/128/color/\(symbolNameAlone.lowercased()).png"
                        ),
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 128)
                        },
                        placeholder: {
                            //ProgressView()
                            PlaceHolderIcon(symbolname: symbolNameAlone)
                                //.frame(width: 128, height: 128, alignment: .center)
                        }
                    )
                        .frame(width: 128, height: 128, alignment: .center)
                        //.padding(.all, 5)
                    VStack {
                        Text("\(symbolName)")
                            .font(.title)
                            .fontWeight(.bold)
                            //.padding(.top, 20)
                        
                        // https://stackoverflow.com/questions/29560743/swift-remove-trailing-zeros-from-double
                        if self.price_history != nil {
                            Text("$\(Double(self.price_history!.lastPrice)!.removeZerosFromEnd()) PER \(symbolNameAlone)")
                            .font(.body)
                            //.fontWeight(.bold)
                            .padding(.top, 5)
                            HStack{
                                Text("24H:")
                                    .font(.body)
                                Text("\(self.price_history!.priceChangePercent)%")
                                    .font(.body)
                                    //.fontWeight(.bold)
                                    //.padding(.top, 5)
                                    .foregroundColor((Double(self.price_history!.priceChangePercent)! > 0) ? .green : .red)
                            }
                            HStack{
                                Text("1H:")
                                    .font(.body)
                                
//                                var data = self.asset_data?.data
//
                                Text("\( String(format: "%.3f", self.asset_data?.quote.usd.percentChange1H ?? 0) )%")
                                    .font(.body)
                                    .foregroundColor((self.asset_data?.quote.usd.percentChange1H ?? 0 > 0) ? .green : .red)
                            }
                            HStack{
                                Text("7D:")
                                    .font(.body)
                                
//                                var data = self.asset_data?.data
//
                                Text("\( String(format: "%.3f", self.asset_data?.quote.usd.percentChange7D ?? 0))%")
                                    .font(.body)
                                    .foregroundColor((Double(self.asset_data?.quote.usd.percentChange7D ?? 0) > 0) ? .green : .red)
                            }
                            HStack{
                                Text("30D:")
                                    .font(.body)
                                
//                                var data = self.asset_data?.data
//
                                Text("\( String(format: "%.3f", self.asset_data?.quote.usd.percentChange30D ?? 0) )%")
                                    .font(.body)
                                    .foregroundColor((Double(self.asset_data?.quote.usd.percentChange30D ?? 0) > 0) ? .green : .red)
                            }
                            HStack{
                                Text("60D:")
                                    .font(.body)
                                
//                                var data = self.asset_data?.data
//
                                Text("\( String(format: "%.3f", self.asset_data?.quote.usd.percentChange60D ?? 0) )%")
                                    .font(.body)
                                    .foregroundColor((Double(self.asset_data?.quote.usd.percentChange60D ?? 0) > 0) ? .green : .red)
                            }
                        
                  
                            
                        }
                        else{
                            Text("Loading Price Data...")
                        }
                    }
                    .padding()
                }
                
                VStack {
                    FilledLineChart(chartData: data)
                        .filledTopLine(chartData: data,
                                       lineColour: ColourStyle(colour: .red),
                                       strokeStyle: StrokeStyle(lineWidth: 3))
                        .touchOverlay(chartData: data, unit: .suffix(of: "Steps"))
                        .pointMarkers(chartData: data)
//                        .yAxisPOI(chartData: data,
//                                  markerName: "Highest Close Price",
//                                  markerValue: highest,
//                                  labelPosition: .center(specifier: "%.000f"),
//                                  labelColour: Color.black,
//                                  labelBackground: Color(red: 1.0, green: 0.75, blue: 0.25),
//                                  lineColour: Color(red: 1.0, green: 0.75, blue: 0.25),
//                                  strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
//                        .yAxisPOI(chartData: data,
//                                  markerName: "Lowest Close Price",
//                                  markerValue: lowest,
//                                  labelPosition: .center(specifier: "%.000f"),
//                                  labelColour: Color.white,
//                                  labelBackground: Color(red: 0.25, green: 0.75, blue: 1.0),
//                                  lineColour: Color(red: 0.25, green: 0.75, blue: 1.0),
//                                  strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                        .averageLine(chartData: data,
                                     strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                        .xAxisGrid(chartData: data)
                        .yAxisGrid(chartData: data)
                        .xAxisLabels(chartData: data)
                        .yAxisLabels(chartData: data)
                        .headerBox(chartData: data)
                        .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
                        .id(data.id)
                        .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 400, maxHeight: 500, alignment: .center)
                        .padding(.horizontal)
                }
            }
        }
//        .refreshable {
//            print("REFRESH GESTURE INVOKED")
//            Task {
//                // WARNING: THIS DONE ON REFRESH
//                // WARNING: THIS DONE ON REFRESH
//                // WARNING: THIS DONE ON REFRESH
//                // WARNING: THIS DONE ON REFRESH
//                // WARNING: THIS DONE ON REFRESH
//                // we await price data
//                async let load1: () = await viewModel.fetchprice_for_symbol(symbolName: self.symbolName)
//                {
//                    fetched_price in DispatchQueue.main.async {
//                        self.price = fetched_price
//                    }
//                }
//
//                async let load2: () = await viewModel.fetch24price_change_for_symbol(symbolName: self.symbolName)
//                {
//                    price_change in DispatchQueue.main.async {
//                        self.priceChange = price_change
//                        self.price_percentage_hour_change = ( self.priceChange[1] - self.priceChange[0] )/(self.priceChange[0])
//                    }
//                }
//                
//                async let load3: () = await viewModel.cryptoInformationService.get_historic_kline_data(symbolName: self.symbolName, interval: interval, limit: limit)
//                {
//                    historic_kline_data in DispatchQueue.main.async {
//                        print("historic_kline_data -> :", historic_kline_data)
//                        
//                        // with historic_kline_data generate LineDataSet close
//                        //let close = historic_kline_data.map { $0.close }
//
//                        data = historic_kline_data
//
//                    }
//                }
//                
//                let pricedata: [()] = await [load1, load2, load3]
//
//                isLoading = false
//
//                print("viewModel.fetchprice_for_symbol -> :", self.price)
//                print("viewModel.fetchprice_for_symbol -> :", self.priceChange)
//                print("price_percentage_hour_change -> :", self.price_percentage_hour_change)
//                // WARNING: THIS DONE ON REFRESH
//                // WARNING: THIS DONE ON REFRESH
//                // WARNING: THIS DONE ON REFRESH
//            }
//        }
        .onAppear{
            // dispatch for current price right now on appear of the scroll view
            DispatchQueue.main.async {
                Task {
                    
                    DispatchQueue.main.async {
                        Task {
                            // we await price data
                            await viewModel.fetchprice_for_symbol(symbolName: self.symbolName)
                            {
                                fetched_price in DispatchQueue.main.async {
                                    self.price = fetched_price
                                    
                                    DispatchQueue.main.async {
                                        Task {
                                    await viewModel.fetch24price_change_for_symbol(symbolName: self.symbolName)
                                    {
                                        
                //                        price_history_summary.openPrice
                //                        price_history_summary.lastPrice
                                        
                                        price_history in DispatchQueue.main.async {
                                            //self.priceChange = price_change
                                            self.price_history = price_history
                                            self.price_percentage_hour_change = ( Double(price_history.lastPrice)! - Double(price_history.openPrice)! )/(Double(price_history.openPrice)!)
                                            
                                            DispatchQueue.main.async {
                                                Task {
                                                    
                                            await viewModel.cryptoInformationService.get_historic_kline_data(symbolName: self.symbolName, interval: interval, limit: limit)
                                            {
                                                historic_kline_data in DispatchQueue.main.async {
                                                    print("historic_kline_data -> :", historic_kline_data)
                                                    
                                                    // with historic_kline_data generate LineDataSet close
                                                    //let close = historic_kline_data.map { $0.close }

                                                    data = historic_kline_data
                                                    
                                                    DispatchQueue.main.async {
                                                        Task {
                                                    await viewModel.cryptoInformationService.fetch_coinmarket_cap_data(symbol: self.symbolNameAlone)
                                                    {
                                                        data2 in DispatchQueue.main.async {
                                                            print("asset_data -> :", data2)
                                                            
                                                            // with historic_kline_data generate LineDataSet close
                                                            //let close = historic_kline_data.map { $0.close }

                                                            //asset_data = data2.data//Datum()//Datum(data2.data)
                                                            //print(asset_data)
                                                            
                                                            let keys = data2.data.map{$0.key}
                                                            let values = data2.data.map {$0.value}
                                                            
                                                            for key in keys.indices {
                                                                asset_data = values[key]
                                                                break;
                                                            }
                                  
                                                            isLoading = false
                                                            
                                                        }
                                                    }
                                                        }}
                          
                                                }
                                            }
                                                }}
                                        }
                                    }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }

                    
                    
                    
                    
                    
                    
                    

                    //let _: [()] = await [load1, load2, load3, load4]

                    //isLoading = false
                    
                    //print("Loaded??")

//                            print("viewModel.fetchprice_for_symbol -> :", self.price)
//                            print("viewModel.fetchprice_for_symbol -> :", self.priceChange)
//                            print("price_percentage_hour_change -> :", self.price_percentage_hour_change)
                }
            }
        }
        .onDisappear {
            
            isLoading = false;
            
        }
    } // end of view
    
} // end of classimport SwiftUI

