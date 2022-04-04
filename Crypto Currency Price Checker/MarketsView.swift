//
//  MarketsView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 04/04/2022.
//

import Foundation
import SwiftUI

/*
 MarketsView Navigation Link View Object
*/
struct NavigationLinkView: View {

    @ObservedObject var viewModel: CCPCViewModel
    @State var symbolName: String = "" // the full name of the symbol
    @State var symbolNameAlone: String = "" // the symbolname stand alone removing USDT
    @State var price: Double = 0 // stores price of currencies

    @State var isLoading: Bool = true // async loading variable for this view

    init(symbolName: String, activeViewModel: CCPCViewModel)
    {
        self.symbolName = symbolName
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
                ScrollView{
                // if not loading, show the symbol information
                    VStack {
                        
                        Text("\(symbolName)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        Text("$\(self.price) PER \(symbolNameAlone)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
//                        Text("\(symbolIcon)")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                            .padding(.top, 20)
                    //https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/32/color/btc.png
                        AsyncImage(url: URL(string:"https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/32/color/\(symbolNameAlone.lowercased()).png"))
                        //AsyncImage(url: URL(string:"https://i.redd.it/1lcjhrmv57f61.jpg")) //"https://cryptoicons.org/api/icon/\(symbolNameAlone)/200"))
                    }
                }
            }
        }
        .refreshable {
            print("REFRESH GESTURE INVOKED")
            Task {
                // we await price data
                await viewModel.fetchprice_for_symbol(symbolName: self.symbolName) {
                    
                    second_fetched_price in DispatchQueue.main.async {
                        self.price = second_fetched_price
                        isLoading = false
                    }
                }
                print("viewModel.fetchprice_for_symbol -> :", self.price)
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
                    await viewModel.fetchprice_for_symbol(symbolName: self.symbolName) {
                        
                        second_fetched_price in DispatchQueue.main.async {
                            self.price = second_fetched_price
                            isLoading = false
                        }
                    }
                    print("viewModel.fetchprice_for_symbol -> :", self.price)
                }
            }
        }
        
    }
}

// this view is invoked on when the user wants to view the market of all crypto currencies
struct MarketsView: View {
    
    @ObservedObject var viewModel: CCPCViewModel
    @State private var searchText = ""
    
    @StateObject var favorites = Favorites()
    
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
                        AsyncImage(url: URL(string:"https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/32/color/\(String(String(symbol).dropLast(4)).lowercased()).png"))
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
                        
//                        Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
//                            if favorites.contains(resort) {
//                                favorites.remove(resort)
//                            } else {
//                                favorites.add(resort)
//                            }
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .padding()
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
