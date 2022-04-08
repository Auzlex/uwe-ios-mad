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

// USEFUL FOR IMAGE STUFF: https://sfsymbols.com/
struct ContentView: View {
    @ObservedObject var viewModel: CCPCViewModel
    @State var isLoading = true // used to switch views to the loading view when we are loading crypto assets
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

                /*

                    MARKETS NAVIGATION VIEW

                */
                NavigationView {
                    if isLoading {
                        LoadingView()
                    } else {
                        // load the markets view
                        MarketsView(viewModel: self.viewModel)
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
                    .environmentObject(favorites)
                    .onAppear {
                        // perform an asynchronous task that will perform fetching view model data
                        DispatchQueue.main.async {
                            Task{
                                await viewModel.refresh() // wait for it to fetch new data
                                isLoading = false // once we have our data switch views
                            }
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
                .environmentObject(favorites)
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Favourites")
                }
                
        }
        .preferredColorScheme(.dark)
    }
}

//https://www.hackingwithswift.com/books/ios-swiftui/letting-the-user-mark-favorites

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel:CCPCViewModel(cryptoInformationService: CryptoInformationService()))
    }
}
