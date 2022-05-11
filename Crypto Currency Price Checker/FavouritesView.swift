//
//  FavouritesView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 29/04/2022.
//

import Foundation
import SwiftUI

// view for the favourites
struct FavouritesView: View {
    
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
        
        List {
            
            // for every element that is in the search results display the list of elements
            // NOTE: this will display all and is determined by the search indexing filter code below this segment
            ForEach(searchResults, id: \.self) { symbol in
                
                // check if the symbol is in our favourites
                if( favorites.contains(symbol) )
                {
                    
                    // create a navigation link to view a navigation link view object that is customizable
                    NavigationLink(
                        destination: AssetView(symbolName: symbol, activeViewModel: viewModel),
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
                                    PlaceHolderIcon(symbolname: symbol)
    //                                    .frame(width: 32, height: 32)
                                }
                            )
                            .frame(maxWidth: 32, maxHeight: 32, alignment: .center)
    //                            .frame(width: 32, height: 32, alignment: .center)
                            Text("\(symbol)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                            Spacer()
                            
                            // removed due to API restriction
//                            Text("+5%")
//                                .foregroundColor(Color.green)
//                                .frame(alignment: .trailing)
//                                .padding()

                    
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
                    
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) // https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data
        .navigationBarTitle("Favourite Crypto Assets")
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
