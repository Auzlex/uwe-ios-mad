//
//  MarketsView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 04/04/2022.
//

import Foundation
import SwiftUI
import SwiftUICharts

/*
 MarketsView Navigation Link View Object
*/


struct NavigationLinkView: View {

    @ObservedObject var viewModel: CCPCViewModel
    @State var symbolName: String = "" // the full name of the symbol
    @State var symbolPrecision: Int = 2 // default is round to 2 decimal places
    @State var symbolNameAlone: String = "" // the symbolname stand alone removing USDT
    @State var price: Double = 0 // stores price of currency
    @State var priceChange: [Double] = [ 0, 0 ] // stores price change data
    @State var price_percentage_hour_change: Double = 0 // stores percentage of price change

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
                             metadata: ChartMetadata(title: "Some Data", subtitle: "A Week"),
                             xAxisLabels: ["Monday", "Thursday", "Sunday"],
                             chartStyle: LineChartStyle(infoBoxPlacement: .header,
                                                        markerType: .full(attachment: .point),
                                                        xAxisLabelsFrom: .chartData(rotation: .degrees(0)),
                                                        baseline: .minimumWithMaximum(of: 5000)))
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
            print("symbolPrecision: " , foundelement.element.baseAssetPrecision)
            print("quotePrecision: " , foundelement.element.quotePrecision)
            print("quoteAssetPrecision: " , foundelement.element.quoteAssetPrecision)
            print("quoteCommissionPrecision: " , foundelement.element.quoteCommissionPrecision)
            print("baseAsset: " , foundelement.element.baseAsset)
        } else {
           print("no symbol precision could have been found for this symbol")
        }
    
        self.symbolNameAlone = String(String(symbolName).dropLast(4))
        self.viewModel = activeViewModel
    }

    var body: some View {
        NavigationView {

            // if is loading, show loading view
            if isLoading {
                LoadingView()
                
            }
            else {
                ScrollView {
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
                                      markerName: "Step Count Aim",
                                      markerValue: 15_000,
                                      labelPosition: .center(specifier: "%.0f"),
                                      labelColour: Color.black,
                                      labelBackground: Color(red: 1.0, green: 0.75, blue: 0.25),
                                      lineColour: Color(red: 1.0, green: 0.75, blue: 0.25),
                                      strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                            .yAxisPOI(chartData: data,
                                      markerName: "Minimum Recommended",
                                      markerValue: 10_000,
                                      labelPosition: .center(specifier: "%.0f"),
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
                            .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                            .padding(.horizontal)
                    }
                    //.navigationTitle("Filled Line")
                    
                    
                // if not loading, show the symbol information
//                    VStack {
//
//                        Text("\(symbolName)")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                            .padding(.top, 20)
//                        Text("$\(self.price) PER \(symbolNameAlone)")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                            .padding(.top, 20)
//                        Text("\(self.price_percentage_hour_change)% 24h")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                            .padding(.top, 20)
                    
                        
                        //https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/32/color/btc.png
//                        AsyncImage(url: URL(string:"https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/32/color/\(symbolNameAlone.lowercased()).png"))
                    //}
                }
                
            }
            
        }
        .navigationBarTitle("") // define navigation view title
        .navigationTitle("") // TODO: cant remove the top title charles
        .refreshable {
            print("REFRESH GESTURE INVOKED")
            Task {
                // WARNING: THIS DONE ON REFRESH
                // WARNING: THIS DONE ON REFRESH
                // WARNING: THIS DONE ON REFRESH
                // WARNING: THIS DONE ON REFRESH
                // WARNING: THIS DONE ON REFRESH
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
                
                
                
                let pricedata: [()] = await [load1, load2]
                
                isLoading = false
                
                print("viewModel.fetchprice_for_symbol -> :", self.price)
                print("viewModel.fetchprice_for_symbol -> :", self.priceChange)
                print("price_percentage_hour_change -> :", self.price_percentage_hour_change)
                // WARNING: THIS DONE ON REFRESH
                // WARNING: THIS DONE ON REFRESH
                // WARNING: THIS DONE ON REFRESH
            }
        }
        .onAppear{
            // fetch the symbol data from the exchange

            // wait 3 seconds
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //self.isLoading = true
                //await self.viewModel.fetchprice_for_symbol(symbolName: self.symbolName)
                self.isLoading = false
            }*/

            DispatchQueue.main.async {
                Task {
                    // we await price data
//                    await viewModel.fetchprice_for_symbol(symbolName: self.symbolName) {
//
//                        second_fetched_price in DispatchQueue.main.async {
//                            self.price = second_fetched_price
//                            isLoading = false
//                        }
//                    }
//                    print("viewModel.fetchprice_for_symbol -> :", self.price)
                    
                    // WARNING: THIS DONE ON REFRESH
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
                    
                    
                    
                    let pricedata: [()] = await [load1, load2]
                    
                    isLoading = false
                    
                    print("viewModel.fetchprice_for_symbol -> :", self.price)
                    print("viewModel.fetchprice_for_symbol -> :", self.priceChange)
                    print("price_percentage_hour_change -> :", self.price_percentage_hour_change)
                }
            }
        }
        .navigationTitle("")
    }
    
}

// this view is invoked on when the user wants to view the market of all crypto currencies
struct MarketsView: View {
    
    @ObservedObject var viewModel: CCPCViewModel
    @State private var searchText = ""
 
    @EnvironmentObject var favorites: Favorites
    
    init(viewModel: CCPCViewModel)
    {
        self.viewModel = viewModel
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20, weight: .bold) //UIFont(name: "Georgia-Bold", size: 20)!
        ]
    }
    
    var body: some View {
        
        // list element
        List {
            
            // for every element that is in the search results display the list of elements
            // NOTE: this will display all and is determined by the search indexing filter code below this segment
            ForEach(searchResults, id: \.self) { symbol in
                
                // create a navigation link to view a navigation link view object that is customizable
                NavigationLink(
                    destination: NavigationLinkView(symbolName: symbol, activeViewModel: viewModel),
                    label: {
                        AsyncImage(
                            url:URL(string:"https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/32/color/\(String(String(symbol).dropLast(4)).lowercased()).png"),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 32)
                            },
                            placeholder: {
                                //ProgressView()
                                Image("nosign")
                            }
                        )
                        Text("\(symbol)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                        Spacer()
                        Text("+5%")
                            .foregroundColor(Color.green)
                            .frame(alignment: .trailing)
                            .padding()
//                                        Text("☆")
//                                            .padding()
//                                        Text("★")
//                                            .foregroundColor(Color.yellow)
//                                            .padding()
                        
                        
                        Button(favorites.contains(symbol) ? "★" : "☆") {
                            if favorites.contains(symbol) {
                                favorites.remove(symbol)
                            } else {
                                favorites.add(symbol)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        //.padding()
                    }
                    
                    // on open of the link do a htttp request to get the price of the crypto asset
                    //https://api.binance.com/api/v3/ticker/price?symbol=


                )
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
//                .background(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255))
//                .cornerRadius(5)
//                .border(Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255), width: 1)
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText) // https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data
        .navigationBarTitle("Crypto Assets")
    }

    /*
        search result query code for browser
    */
    // determines what elements are returned when we search for an item within the markets view
    var searchResults: [String] {
        if searchText.isEmpty {
            return viewModel.symbols.map { $0.symbol }
        } else {
            return viewModel.symbols.filter { $0.symbol.lowercased().contains(searchText.lowercased()) }.map { $0.symbol }
        }
    }
    
}
