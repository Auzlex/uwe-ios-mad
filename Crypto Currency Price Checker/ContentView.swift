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

/*
 
    Tab View Style
 
 */

//struct HighlightedMenuItem: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .padding([.leading, .trailing])
//            .padding([.top, .bottom], 4)
//            .foregroundColor(Color(UIColor.black))
//    }
//}
//
//struct UnhighlightedMenuItem: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .padding([.leading, .trailing])
//            .padding([.top, .bottom], 4)
//    }
//}
//
//extension View {
//    func highlighted() -> some View {
//        self.modifier(HighlightedMenuItem())
//    }
//
//    func unhighlighted() -> some View {
//        self.modifier(UnhighlightedMenuItem())
//    }
//}
//
//struct MainHeaderView: View {
//    @Binding var selectedIndex: Int
//    @Environment(\.colorScheme) var colorScheme
//    @Namespace private var tabSelection
//
//    var body: some View {
//        HStack{
//            Spacer()
//            if selectedIndex == 0 {
//                Text("First")
//                    .highlighted()
//                    .background(menuCapsule)
//            } else {
//                Text("First")
//                    .unhighlighted()
//                    .onTapGesture {selectedIndex = 0 }
//            }
//            Spacer()
//            if selectedIndex == 1 {
//                Text("Second")
//                    .highlighted()
//                    .background(menuCapsule)
//            } else {
//                Text("Second")
//                    .unhighlighted()
//                    .onTapGesture {selectedIndex = 1 }
//            }
//            Spacer()
//            if selectedIndex == 2 {
//                Text("Third")
//                    .highlighted()
//                    .background(menuCapsule)
//            } else {
//                Text("Third")
//                    .unhighlighted()
//                    .onTapGesture {selectedIndex = 2 }
//            }
//            Spacer()
//        }
//        .frame(maxWidth: .infinity)
//        .padding(8)
//        .font(.subheadline)
//        .foregroundColor(colorScheme == .dark ? Color(UIColor.lightText) : Color(UIColor.darkGray))
//        .animation(.easeOut(duration: 0.2), value: selectedIndex)
//    }
//    var menuCapsule: some View {
//        Capsule()
//            .foregroundColor(.yellow)
//            .matchedGeometryEffect(id: "capsule", in: tabSelection)
//    }
//}

// USEFUL FOR IMAGE STUFF: https://sfsymbols.com/
struct ContentView: View {
    
//    @State var selectedIndex = 0
//    @Environment(\.colorScheme) var colorScheme
    
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
        
        UINavigationBar.appearance().barTintColor = UIColor.systemBackground
        UINavigationBar.appearance().backgroundColor = UIColor.systemBackground
        UITabBar.appearance().barTintColor = UIColor.systemBackground
        
        //UITabBar.appearance().tintColor = UIColor.gray
        
//        UITabBarItem.appearance()
//            //.seleted.iconColor = .white
//            .setTitleTextAttributes(
//                [.font : UIFont.systemFont(ofSize: 15, weight: .medium)],
//            for: .normal)
//            //.set
    }
    
    var body: some View {
        
        // https://www.appcoda.com/swiftui-tabview/
        TabView() {
                /*

                HOME NAVIGATION VIEW

                */
                // create a navigation view
                NavigationView {
//                    Text("IMPLEMENT_DASHBOARD_VIEW ")
//                        .navigationBarTitle("Crypto Dashboard") // define navigation view title
                    
                    DashboardView(viewModel: self.viewModel)
                    
                }
                .environmentObject(favorites)  // this passes the environment object so we can determine what is favourited or not
                .tag(1)
                .tabItem {
                    //Image(systemName: "house.fill").font(.system(size: 26))
                    Text("Dashboard")
                }
                .accentColor(.black)
                
            
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
                            //.navigationTitle("")
                        
                    }
                        
                }
                //.navigationTitle("")
                //.onAppear(perform: viewModel.refresh)
                .environmentObject(favorites)  // this passes the environment object so we can determine what is favourited or not from the markets view
                .onAppear {
                    // perform an asynchronous task that will perform fetching view model data
                    DispatchQueue.main.async {
                        Task{
                            await viewModel.refresh() // wait for it to fetch new data
                            isLoading = false // once we have our data switch views
                        }
                    }
                }
                .tag(2)
                .tabItem {
                    //Image(systemName: "chart.bar")
                    Text("Markets")
                }
                .accentColor(.black)
            
                /*
                    FAVOURITES VIEW
                */
            
                NavigationView {
                    
                    if isLoading {
                        LoadingView()
                    } else {
                        // load the markets view
                        FavouritesView(viewModel: self.viewModel)

                    }
                
                    
//                    Text("IMPLEMENT_FAVOURITES_VIEW")
//                    .navigationBarTitle("Favourite Crypto Assets")
//                    .searchable(text: $searchText)
                    
                }
                .environmentObject(favorites) // passes the environment favourites to the
                .onAppear {
                    // perform an asynchronous task that will perform fetching view model data
                    DispatchQueue.main.async {
                        Task{
                            await viewModel.refresh() // wait for it to fetch new data
                            isLoading = false // once we have our data switch views
                        }
                    }
                }
                .tag(3)
                .tabItem {
                    //Image(systemName: "bookmark.fill")
                    Text("Favourites")
                }
                .accentColor(.black)
                
        }
        
        .accentColor(.yellow)
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//        MainHeaderView(selectedIndex: $selectedIndex)
        //.preferredColorScheme(.dark)s
    }
}

//https://www.hackingwithswift.com/books/ios-swiftui/letting-the-user-mark-favorites

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel:CCPCViewModel(cryptoInformationService: CryptoInformationService()))
    }
}
