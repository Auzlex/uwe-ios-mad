//
//  ContentView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 11/02/2022.
//

import SwiftUI

// loading view
struct LoadingView: View {
    var body: some View {
        ProgressView()
    }
}

// This view is called upon by the navigation link
// displays the information for given symbolName
struct NavigationLinkView: View {

    @ObservedObject var viewModel: CCPCViewModel
    @State var symbolName: String = ""
    @State var symbolNameAlone: String = ""
    @State var symbolIcon: String = ""
    //@ObservedObject var imageLoader:ImageLoader
    //@State var image:UIImage = UIImage()
    @State var price: Double = 0

    @State var isLoading: Bool = true

    init(symbolName: String, activeViewModel: CCPCViewModel)
    {
        self.symbolName = symbolName
        self.symbolNameAlone = String(String(symbolName).dropLast(4))
        self.viewModel = activeViewModel
        
//        //https://cryptoicons.org/api/icon/eth/200
//        // Create URL
//        let url = URL(string: "https://cryptoicons.org/api/icon/\(symbolNameAlone)/200")!
//
//        DispatchQueue.global().async {
//            // Fetch Image Data
//            if let data = try? Data(contentsOf: url) {
//                DispatchQueue.main.async {
//                    // Create Image and Update Image View
//                    self.image = UIImage(data: data)
//                }
//            }
//        }
        
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
                        Text("\(symbolIcon)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        AsyncImage(url: URL(string:"https://i.redd.it/1lcjhrmv57f61.jpg")) //"https://cryptoicons.org/api/icon/\(symbolNameAlone)/200"))
                        
                        
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
                //await viewModel.refresh()
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


// USEFUL FOR IMAGE STUFF: https://sfsymbols.com/
struct ContentView: View {
    @ObservedObject var viewModel: CCPCViewModel
    @State var isLoading = true // used to switch views to the loading view when we are loading crypto assets
    @State private var searchText = ""
    
    init(viewModel: CCPCViewModel)
    {
        self.viewModel = viewModel
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 20, weight: .bold) //UIFont(name: "Georgia-Bold", size: 20)!
        ]
    }
    
    var body: some View {
        
        // https://www.appcoda.com/swiftui-tabview/
        TabView {
                

                /*

                HOME NAVIGATION VIEW

                */
            
                // create a navigation view
                NavigationView{
                    Text("IMPLEMENT_DASHBOARD_VIEW ")
                        .navigationBarTitle("Crypto Dashboard") // define navigation view title
                }
                    //.badge(5)
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
//                List(1...10, id: \.self) { index in
//                    NavigationLink(
//                        destination: Text("Item #\(index) Details"),
//                        label: {
//                            Text("Item #\(index)")
//                                .font(.system(size: 20, weight: .bold, design: .rounded))
//                        }
//                    )
//
//                }
            
                /*

                    MARKETS NAVIGATION VIEW

                */
            
                NavigationView {
                    if isLoading {
                        LoadingView()
                    } else {
                        //DoneLoadingView()
                        List { //(viewModel.symbols, id: \.self) { symbol in
                            ForEach(searchResults, id: \.self) { symbol in
                                NavigationLink(
                                    destination: NavigationLinkView(symbolName: symbol, activeViewModel: viewModel),
                                    label: {
                                        Text("\(symbol)")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                    }
                                    // on open of the link do a htttp request to get the price of the crypto asset
                                    //https://api.binance.com/api/v3/ticker/price?symbol=


                                )
                                
                                // disable from here
                                HStack
                                {
                                    Text(symbol)
                                        .padding()
                                        .foregroundColor(Color.white)
                                        //.background(Color.gray)
            
                                    Spacer()
                                    Text("+5%")
                                        .foregroundColor(Color.green)
                                        .frame(alignment: .trailing)
                                        .padding()
                                    Text("☆")
                                        .padding()
                                    Text("★")
                                        .foregroundColor(Color.yellow)
                                        .padding()
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                                .background(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255))
                                .cornerRadius(5)
                                .border(Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255), width: 1)
                                // to here this was experimental
                            }
                        }
                        .searchable(text: $searchText) // https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data
                        .navigationBarTitle("Crypto Assets")
                        .refreshable {
                            // this code is invoked on refresh gesture for this tab
                            print("REFRESH SYMBOLS: isloading False")
                            isLoading = false
                            DispatchQueue.main.async {
                                Task{
                                    await viewModel.refresh()
                                    isLoading = false // tells our view we are ready to view once loaded
                                    print("REFRESH SYMBOLS: isloading TRUE")
                                }
                            }
                        }
                    }
                        
                }
                    //.onAppear(perform: viewModel.refresh)
                    .onAppear {
                        DispatchQueue.main.async {
                            //await viewModel.refresh()
                            Task{
                                await viewModel.refresh()
                                isLoading = false // tells our view we are ready to view once loaded
                            }
                            //viewModel.refresh()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                            isLoading = false
//                                        }
                            //isLoading = false
                        }
                    }
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Markets")
                    }
            
                /*
                
                    FAVOURITES VIEW
                 
                */
            
                NavigationView{
                    Text("IMPLEMENT_FAVOURITES_VIEW")
                    .navigationBarTitle("Favourite Crypto Assets")
                    .searchable(text: $searchText)
                    
                }
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Favourites")
                }
                
        }
        .preferredColorScheme(.dark)
//        NavigationView {
//            ScrollView {
//                VStack {
//                    //Color.black.edgesIgnoringSafeArea(.all)
//                    //Text("Sample Text")
//                    //    .padding()
//                    //.frame(maxWidth: .infinity)
//
////                    ForEach((1...15), id: \.self) { _ in
////                        HStack
////                        {
////                            Text("SAMPLE BTC")
////                                .padding()
////                                .foregroundColor(Color.white)
////                                //.background(Color.gray)
////
////                            Spacer()
////                            Text("+5%")
////                                .foregroundColor(Color.green)
////                                .frame(alignment: .trailing)
////                                .padding()
////                            Text("☆")
////                                .padding()
////                            Text("★")
////                                .foregroundColor(Color.yellow)
////                                .padding()
////                        }
////                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
////                        .background(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255))
////                        .cornerRadius(5)
////                    }
//
//                    ForEach(viewModel.symbols, id: \.self) { symbol in
//                        HStack
//                        {
//                            Text(symbol.symbol)
//                                .padding()
//                                .foregroundColor(Color.white)
//                                //.background(Color.gray)
//
//                            Spacer()
//                            Text("+5%")
//                                .foregroundColor(Color.green)
//                                .frame(alignment: .trailing)
//                                .padding()
//                            Text("☆")
//                                .padding()
//                            Text("★")
//                                .foregroundColor(Color.yellow)
//                                .padding()
//                        }
//                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
//                        .background(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255))
//                        .cornerRadius(5)
//                        //.border(Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255), width: 1)
//
//                    }
//                }
//                .onAppear(perform: viewModel.refresh)
//                .frame(minWidth: 0, maxWidth: .infinity)
//                .padding([.leading, .trailing], 20)
//                //Color.black.edgesIgnoringSafeArea(.all)
//                //.padding(.top, UIApplication.shared.windows.first!.safeAreaInsets.top )
//                //.navigationViewStyle(StackNavigationViewStyle())
//                //.background(Color.black.edgesIgnoringSafeArea(.all))
//                .preferredColorScheme(.dark)
//
//                /*.frame(
//                      minWidth: 0,
//                      maxWidth: .infinity,
//                      minHeight: 0,
//                      maxHeight: .infinity,
//                      alignment: .topLeading
//                    )*/
//            }
//            .navigationTitle("Sample Text")
//
//            // edge: .bottom, alignment: .trailing
//            // edge: .bottom, alignment: .center, spacing: 0
//            .safeAreaInset(edge: .bottom, alignment: .trailing, spacing: 0) {
//
//                /*Color.clear
//                    .frame(height: 20)
//                    .background(Material.bar)*/
//                Text("Outside Safe Area")
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Material.bar)
////                Button {
////                    print("Show help")
////                } label: {
////                    Image(systemName: "info.circle.fill")
////                        .font(.largeTitle)
////                        .symbolRenderingMode(.multicolor)
////                        .padding(.trailing)
////                }
////                .accessibilityLabel("Show help")
//
//
//            }
//        }
    }

    /* 

        search result query code for browser

    */

    // func searchResult(for query: String) -> [String] {
    //     return viewModel.symbols.filter { $0.symbol.lowercased().contains(query.lowercased()) }.map { $0.symbol }
    // }

    // update var searchResults to return filtered symbols

    var searchResults: [String] {
        if searchText.isEmpty {
            return viewModel.symbols.map { $0.symbol }
        } else {
            return viewModel.symbols.filter { $0.symbol.lowercased().contains(searchText.lowercased()) }.map { $0.symbol }
        }
        //return viewModel.symbols.filter { $0.symbol.lowercased().contains(searchText.lowercased()) }.map { $0.symbol }
    }

    // var searchResults: [String] {
    //     if searchText.isEmpty {
    //         return viewModel.symbols
    //     } else {
    //         return viewModel.symbols.filter { $0.contains(searchText) }
    //     }
    // }

    
}

//https://www.hackingwithswift.com/books/ios-swiftui/letting-the-user-mark-favorites

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        TabView {
//            //Text("The First Tab")
//            ContentView(viewModel:CCPCViewModel(cryptoInformationService: CryptoInformationService()))
//                //.badge(10)
//                .tabItem {
//                    Image(systemName: "1.square.fill")
//                    Text("Browse")
//                }
//            Text("Another Tab")
//                .tabItem {
//                    Image(systemName: "favorites")
//                    Text("Favourites")
//                }
//            Text("The Last Tab")
//                .tabItem {
//                    Image(systemName: "3.square.fill")
//                    Text("Third")
//                }
//        }
//        .font(.headline)
//        .preferredColorScheme(.dark)
        ContentView(viewModel:CCPCViewModel(cryptoInformationService: CryptoInformationService()))
    }
}
