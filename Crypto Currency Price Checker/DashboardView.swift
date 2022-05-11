//
//  DashboardView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 06/05/2022.
//

import Foundation
import SwiftUI

struct PlaceHolderIcon: View {
    
    @State var symbolname = ""
    
    var body: some View {
        
        return GeometryReader{g in ZStack {
    
            Circle()
                .fill(Color("TextColor"))
                .frame(maxWidth: .infinity, maxHeight:.infinity)   // 2//.frame(width: 32, height: 32)
            Text(symbolname.dropLast(symbolname.count-2))
                    .foregroundColor(Color("TextColorInvert"))
                    .font(.system(size: g.size.height > g.size.width ? g.size.width * 0.2: g.size.height * 0.2))
                    //.minimumScaleFactor(0.001)
                    .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .center) //.frame(width: 32, height: 32, alignment: .center)
                    //.padding()
            
        }
            
        }
    
                
//                .overlay(
//                    Circle()
//                    .stroke(Color.gray, lineWidth: 3)
//                    .padding(16)
//                )
        
        
    }
    
}

// used to put crypto information in
struct AssetQuickView: View {
    
    @ObservedObject var viewModel: CCPCViewModel
    @State var title = "" // stores title of asset
    @State var description = "" // stores quick description
    @State var asset_data: Datum?
    @State var icon = "" // stores name of the icon
    
    
    var body: some View {
        
        return HStack {
            
            NavigationLink(
                destination: AssetView(symbolName: title + "USDT", activeViewModel: viewModel ),
                label: {
                    AsyncImage(
                        url:URL(string:"https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@bea1a9722a8c63169dcc06e86182bf2c55a76bbc/32/color/\(String(icon).lowercased()).png"),
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 32)
                        },
                        placeholder: {
                            //ProgressView()
                            //Image("nosign")
                            PlaceHolderIcon(symbolname: title)
                        }
                    )
                    //.font(.system(size: 30))
                    .frame(width: 50, height: 50)
                    //.background(colors[elem % colors.count])
                    .cornerRadius(10)
                    .padding(.leading, 5)
                    
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color("TextColor"))
                        
                        Text("$\( String(format: "%.3f", self.asset_data?.quote.usd.price ?? 0) )")
                            .font(.system(size: 12))
                            .foregroundColor(Color("TextColor"))
                        
                        Text( "\( String(format: "%.2f", self.asset_data?.quote.usd.percentChange24H ?? 0) )%" )
                            .font(.system(size: 12))
                            .foregroundColor((self.asset_data?.quote.usd.percentChange24H ?? 0 > 0) ? .green : .red )
                    }
                
            })
        }
        .foregroundColor(Color("TextColor"))
        .padding(.trailing, 10)
        .frame(maxWidth: 150, maxHeight: .infinity)
        .background(Color("TextColorInvert"))
        .cornerRadius(15)
        .shadow(color: .gray, radius: 0, x: 1, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 0.7)
        )
        
    }
    
}


struct TodoPG: Identifiable {
    var id = UUID().uuidString
    var source: Source
    var author: String
    var title, articleDescription: String
    var url: String
    var urlToImage: String
}


struct DashboardView: View {
    
    @ObservedObject var viewModel: CCPCViewModel
    @EnvironmentObject var favorites: Favorites
    
    @State var isLoading: Bool = true // async loading variable for this view
    
    @State var text = ""
    
    @State var latest_trends_data: CoinMarketCapData?
    @State var gainers_and_losers_data: CoinMarketCapData?
    @State var news_data: [String] = []
    
    init(viewModel: CCPCViewModel)
    {
        self.viewModel = viewModel
        
        //sprint("DASHBOARD: ", self.viewModel.symbols.count)
        
//        var top_cryptos = [
//
//            "BTC",
//            "ETH",
//
//
//        ]
        
//        // for every symbol fetch price using fetchprice_for_symbol function
//        for symbol in self.viewModel.symbols {
//            self.viewModel.fetchprice_for_symbol(symbolName: symbol.symbol) {
//                fetched_price in
//                print("fetched_price: ", fetched_price)
//            }
//        }
        
    }
    
    private var threeColumnGrid = [GridItem(.flexible())]
    
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]

    private var colors: [Color] = [.yellow, .purple, .green]
    
    var body: some View {

        
        
        VStack {
        
            if isLoading{
                LoadingView()
            }
            else
            {
                
                Text(text)
                    .padding()
                    .lineLimit(1)
                    .fixedSize()
                    //https://swiftuirecipes.com/blog/swiftui-marquee
                    .marquee(duration: 15, direction: .rightToLeft, autoreverse:true )
                    .background(Color.yellow)
                    .foregroundColor(Color.black)
                    //.edgesIgnoringSafeArea(.all)
//                    .frame(
//                      minWidth: 0,
//                      maxWidth: .infinity,
//                      minHeight: 0,
//                      maxHeight: 150,
//                      alignment: .topLeading
//                    )

                
                Text("Top Coins")
                    .bold()
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: threeColumnGrid) {
                        
                        let keys = latest_trends_data!.data.map{$0.key}
                        let values = latest_trends_data!.data.map {$0.value}
                        
                        // Display the item
                        ForEach(keys.indices, id: \.self) { index in
                            
                            
                            
                            AssetQuickView(
                                viewModel: self.viewModel,
                                title: values[index].symbol,
                                description: "ASSET_DESC",
                                asset_data: values[index],
                                icon: values[index].symbol
                            )
                            
                        }
                    }
                    .padding(.bottom, 10) // this adds space all around
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                }
                
                Text("Gainers & Losers")
                    .bold()
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: threeColumnGrid) {
                        
                        let keys = gainers_and_losers_data!.data.map{$0.key}
                        let values = gainers_and_losers_data!.data.map {$0.value}
                        
                        // Display the item
                        ForEach(keys.indices, id: \.self) { index in

                            AssetQuickView(
                                viewModel: self.viewModel,
                                title: values[index].symbol,
                                description: "ASSET_DESC",
                                asset_data: values[index],
                                icon: values[index].symbol
                            )
                            

                        }
                    }
                    .padding(.bottom, 10) // this adds space all around
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                }
                
                Text("Crypto News")
                    .bold()
                ScrollView() {
                    LazyVGrid(columns: threeColumnGrid) {
                        // Display the item
                        // API key for news API https://newsapi.org/v2/everything?q=crypto&apiKey=94ba1e8999df4532816352e87dec286b
                        
                        ForEach(news_data, id: \.self) { article in

                            let data = article.components(separatedBy: "|")
                            
                            HStack {

                                AsyncImage(
                                    url:URL(string:data[0]
                                    ),
                                    content: { image in
                                        image.resizable()
                                            //.aspectRatio(contentMode: .fit)
                                            .frame(width: 125, height: 100)
                                            .cornerRadius(10)
                                            //.jpegData(compressionQuality: 0.2)
                                    },
                                    placeholder: {
                                        ProgressView()
                                        //PlaceHolderIcon(symbolname: symbolNameAlone)
                                            //.frame(width: 128, height: 128, alignment: .center)
                                    }
                                )
                                .font(.system(size: 30))
                                .frame(width: 125, height: 100)
                                //.background(colors[elem % colors.count])
                                .cornerRadius(10)

                                VStack(alignment: .leading) {
                                    Text(data[1])
                                        .font(.body)
                                        .bold()

                                    Text(data[2])
                                        .font(.system(size: 12))
//
                                    Link("View Article", destination: URL(string: data[3])!)
                                }

                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 400)
                            .background(Color("TextColorInvert"))
                            .cornerRadius(15)
                            .shadow(color: .gray, radius: 0, x: 1, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray, lineWidth: 0.7)
                            )
                            //.frame(minWidth:.infinity)



                        }
                    }
                    .padding() // this adds space all around
                }
            }
            
        }
        .foregroundColor(Color("TextColor"))
        .navigationBarTitle("Crypto Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            if isLoading {
                
            
            DispatchQueue.main.async {
                Task{ // fetch_coinmarket_cap_data
                    
                    await viewModel.cryptoInformationService.fetch_coinmarket_cap_data(symbol: "BTC,ETH,DOGE,MATIC,XRP,ATOM,LTC")
                    {
                        
                        data in DispatchQueue.main.async {
                            print("latest_trends_data",data)
                            latest_trends_data = data
                            
                            let keys = latest_trends_data!.data.map{$0.key}
                            let values = latest_trends_data!.data.map {$0.value}
                            
                            text = ""
                            
                            for key in keys.indices {
                                var asset_data = values[key]
                                let percentage = asset_data.quote.usd.percentChange24H ?? 0
                                text += " \(asset_data.symbol) \(String(format: "%.2f",  percentage))%"
                                
                                if(percentage > 0)
                                    
                                {
                                    text += "▲"
                                }
                                else
                                {
                                    text += "▼"
                                }
                                
                                text+="     "
                            }
                            
                            DispatchQueue.main.async {
                                Task{ // fetch_coinmarket_cap_data
                                    await viewModel.cryptoInformationService.fetch_coinmarket_cap_data(symbol: "SHIB,CAKE,APE,DEFI")
                                    {
                                        
                                        data in DispatchQueue.main.async {
                                            print("gainers_and_losers_data",data)
                                            gainers_and_losers_data = data
                
                                            
                                            
                                            DispatchQueue.main.async {
                                                Task{ // fetch_coinmarket_cap_data
                                                    await viewModel.cryptoInformationService.fetch_crypto_news()
                                                    {
                                                        
                                                                                                                
                                                        news_data in DispatchQueue.main.async {
                                                            print("news_data",news_data)
                                                            self.news_data = []
                                                            
                                                            
                                                            // i fucking hate this programming language swift UI is so fucking shite I had to do jank workarounds!
                                                            for article in news_data.articles {
                                                                self.news_data.append( "\(article.urlToImage)|\(article.title)|\(article.articleDescription)|\(article.url)" )

                                                            }
                                
                                                            isLoading = false

                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
//                    let _: [()] = await [load1, load2]
                    
                }
            }
        }
        }
    }
}

//
//public struct ArticleHash: Codable {
//
//    let id = UUID()
//    var source: Source
//    var author: String
//    var title, articleDescription: String
//    var url: String
//    var urlToImage: String
//    var publishedAt: Date
//    var content: String
//
////    var hashValue: Int {
////        return self.id
////    }
//
////    enum CodingKeys: String, CodingKey {
////        case source, author, title
////        case articleDescription = "description"
////        case url, urlToImage, publishedAt, content
////    }
//}
