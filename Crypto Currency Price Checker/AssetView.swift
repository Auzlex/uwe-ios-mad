//
//  AssetView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 29/04/2022.
//

import Foundation
import SwiftUI
import SwiftUICharts

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
    }

    var body: some View {

        ScrollView {
            // if is loading, show loading view
            if isLoading {
                LoadingView()
            }
            else {
                HStack{
                    AsyncImage(url:URL(string:"https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/128/color/\(symbolNameAlone.lowercased()).png")
                    )
                        .padding(.all, 5)
                    VStack {
                        Text("\(symbolName)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            //.padding(.top, 20)
                        Text("$\(self.price, specifier: "%.\(self.symbolPrecision)f") PER \(symbolNameAlone)")
                            .font(.body)
                            //.fontWeight(.bold)
                            .padding(.top, 5)
                        Text("24H CHANGE: \(self.price_percentage_hour_change)% 24h")
                            .font(.body)
                            //.fontWeight(.bold)
                            .padding(.top, 5)
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
                        .yAxisPOI(chartData: data,
                                  markerName: "Highest Close Price",
                                  markerValue: highest,
                                  labelPosition: .center(specifier: "%.000f"),
                                  labelColour: Color.black,
                                  labelBackground: Color(red: 1.0, green: 0.75, blue: 0.25),
                                  lineColour: Color(red: 1.0, green: 0.75, blue: 0.25),
                                  strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                        .yAxisPOI(chartData: data,
                                  markerName: "Lowest Close Price",
                                  markerValue: lowest,
                                  labelPosition: .center(specifier: "%.000f"),
                                  labelColour: Color.white,
                                  labelBackground: Color(red: 0.25, green: 0.75, blue: 1.0),
                                  lineColour: Color(red: 0.25, green: 0.75, blue: 1.0),
                                  strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
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
                    
                    // we await price data
                    async let load1: () = await viewModel.fetchprice_for_symbol(symbolName: self.symbolName)
                    {
                        fetched_price in DispatchQueue.main.async {
                            self.price = fetched_price
                        }
                    }

                    async let load2: () = await viewModel.fetch24price_change_for_symbol(symbolName: self.symbolName)
                    {
                        price_change in DispatchQueue.main.async {
                            self.priceChange = price_change
                            self.price_percentage_hour_change = ( self.priceChange[1] - self.priceChange[0] )/(self.priceChange[0])
                        }
                    }

                    async let load3: () = await viewModel.cryptoInformationService.get_historic_kline_data(symbolName: self.symbolName, interval: interval, limit: limit)
                    {
                        historic_kline_data in DispatchQueue.main.async {
                            print("historic_kline_data -> :", historic_kline_data)
                            
                            // with historic_kline_data generate LineDataSet close
                            //let close = historic_kline_data.map { $0.close }

                            data = historic_kline_data
  
                        }
                    }

                    let _: [()] = await [load1, load2, load3]

                    isLoading = false
                    
                    print("Loaded??")

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

