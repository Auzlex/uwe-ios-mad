//
//  MarketsView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 04/04/2022.
//

import Foundation
import SwiftUI
import RefreshableScrollView



// this view is invoked on when the user wants to view the market of all crypto currencies
struct MarketsView: View {
    
    @ObservedObject var viewModel: CCPCViewModel
    @State private var searchText = ""
    //@State private var price_history
    
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
                    destination: AssetView(symbolName: symbol, activeViewModel: viewModel ), //, price_history:
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
//                        Text("+5%")
//                            .foregroundColor(Color.green)
//                            .frame(alignment: .trailing)
//                            .padding()

                        
                        
                        Button(favorites.contains(symbol) ? "★" : "☆") {
                            if favorites.contains(symbol) {
                                favorites.remove(symbol)
                            } else {
                                favorites.add(symbol)
                            }
                        }
                        .foregroundColor(Color("TextColorInvert"))
                        .buttonStyle(.borderedProminent)
                        //.padding()
                    }
                    
                    // on open of the link do a htttp request to get the price of the crypto asset
                    //https://api.binance.com/api/v3/ticker/price?symbol=


                )
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
//                .onAppear {
//                    DispatchQueue.main.async {
//                        Task {
//                            print("MarketsView -> asset \(symbol) invoked on appear!")
//
//                            async let load1: () = await viewModel.fetch24price_change_for_symbol(symbolName: symbol)
//                            {
//                                price_history in DispatchQueue.main.async {
//                                    print("APPEAR: ", price_history.priceChangePercent)
//                                }
//                            }
//                            let _: [()] = await [load1]
//                        }
//                    }
//
//                }
//                .background(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255))
//                .cornerRadius(5)
//                .border(Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255), width: 1)
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) // https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data
        .navigationBarTitle("Crypto Assets")
        .navigationBarTitleDisplayMode(.inline)
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
