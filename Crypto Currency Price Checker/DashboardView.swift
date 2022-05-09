//
//  DashboardView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 06/05/2022.
//

import Foundation
import SwiftUI

// used to put crypto information in
struct AssetQuickView: View {
    @State var title = "" // stores title of asset
    @State var description = "" // stores quick description
    @State var icon = "" // stores name of the icon
    
    var body: some View {
        
        return HStack {
            
            Image(systemName: icon)
                .font(.system(size: 30))
                .frame(width: 50, height: 50)
                //.background(colors[elem % colors.count])
                .cornerRadius(10)
                .padding(.leading, 10)
            
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.title3)
                    .bold()
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    .font(.system(size: 12))
            }
            
        }
        .frame(maxWidth: 150, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 0, x: 1, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 0.7)
        )
        
    }
    
}

struct DashboardView: View {
    
    @ObservedObject var viewModel: CCPCViewModel
    @EnvironmentObject var favorites: Favorites
    
    @State var text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam eu magna sapien. Nullam sagittis fringilla nulla, quis faucibus eros iaculis quis. Phasellus pellentesque aliquet neque."
    
    init(viewModel: CCPCViewModel)
    {
        self.viewModel = viewModel
        
        print("DASHBOARD: ", self.viewModel.symbols.count)
        
        // for every
        
    }
    
    private var threeColumnGrid = [GridItem(.flexible())]
    
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]

    private var colors: [Color] = [.yellow, .purple, .green]
    
    var body: some View {

        VStack {
        
            VStack (alignment: .leading) {
                    Text(text)
                    .padding()
                    .lineLimit(1)
                    .fixedSize()
                    //https://swiftuirecipes.com/blog/swiftui-marquee
                    .marquee(duration: 15, direction: .rightToLeft, autoreverse:true )
                    .background(Color.yellow)
                    
            }
            //.background(Color.yellow)
//            .frame(width: 230, height: 30)
//            .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
            
            Text("Top Coins")
                .bold()
            ScrollView(.horizontal) {
                LazyHGrid(rows: threeColumnGrid) {
                    // Display the item
                    ForEach((0...10), id: \.self) { elem in
                        
                        AssetQuickView(
                            title: "ASSET_NAME",
                            description: "ASSET_DESC",
                            icon: symbols[elem % symbols.count]
                        )
                        
                    }
                }
                .padding(.bottom, 10) // this adds space all around
                .padding(.leading, 5)
                .padding(.trailing, 5)
            }
            
            Text("Gainers & Losers")
                .bold()
            ScrollView(.horizontal) {
                LazyHGrid(rows: threeColumnGrid) {
                    // Display the item
                    ForEach((0...10), id: \.self) { elem in
                        
                        AssetQuickView(
                            title: "ASSET_NAME",
                            description: "ASSET_DESC",
                            icon: symbols[elem % symbols.count]
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
                    ForEach((0...10), id: \.self) { elem in
                        
                        HStack {
                            
                            Image(systemName: symbols[elem % symbols.count])
                                .font(.system(size: 30))
                                .frame(width: 100, height: 100)
                                .background(colors[elem % colors.count])
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text("Title")
                                    .font(.title3)
                                    .bold()
                                
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam eu magna sapien. Nullam sagittis fringilla nulla, quis faucibus eros iaculis quis. Phasellus pellentesque aliquet neque.")
                                    .font(.system(size: 12))
                            }
                            
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .gray, radius: 0, x: 1, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, lineWidth: 0.7)
                        )
                        
                        

                    }
                }
                .padding() // this adds space all around
            }
            
        }
        .navigationBarTitle("Crypto Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        
    
        
        
        
        
        
        
        
        
        //.navigationBarTitle("Crypto Dashboard")
        
//        // Vstack
//        VStack(alignment: .leading) {
//
//            //ScrollView{
//
//            // NOTE: Removing these 2 vstacks fixes the safe area being ignored????
////                VStack(spacing: 20) {
////                    Text("Top Cryptos")
////                    Text("IMPLEMENT_TOP_CRYPTOS")
////                }
////                .frame(maxWidth: .infinity)
////
////                VStack(spacing: 20) {
////                    Text("Gainers & Losers")
////                    Text("IMPLEMENT_GAINERS_&_LOOSERS")
////                }
////                .frame(maxWidth: .infinity)
//
//                VStack(spacing: 20) {
//                    Text("News")
//                    ScrollView {
//                        ForEach((1...10), id: \.self) { i in
//                            HStack {
//                                AsyncImage(
//                                    url:URL(string:"https://ichef.bbci.co.uk/news/1024/branded_news/1257B/production/_118713157_gettyimages-897291236.jpg"),
//                                    content: { image in
//                                        image.resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(maxHeight: 100)
//                                    },
//                                    placeholder: {
//                                        //ProgressView()
//                                        Image("nosign")
//                                    }
//                                )
//                                .cornerRadius(10)
//                                //.padding(.all, 5)
//                                //.frame(maxWidth: 100, maxHeight: 100)
//                                .frame(width: 100, height: 100)
//                                //.aspectRatio(contentMode: .fit)
//
//                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut quis nunc in ligula pretium varius. Integer velit nulla, posuere in tempor vel, viverra vel ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce interdum in sapien sit amet pharetra. Sed sed risus sed diam commodo tristique et non est. Aenean nec dapibus quam. Vivamus convallis ipsum sed arcu egestas mattis placerat ut elit.")
//                                .padding()
//                                .font(.system(size: 12))
//                                .overlay(
//                                        RoundedRectangle(cornerRadius: 0)
//                                            .stroke(Color.gray, lineWidth: 1)
//                                        )
//                            }
//                        }
//                    }
//                }
//                //.frame(maxWidth: .infinity)//, maxHeight: 400)
//                //.background(Color.gray)
//
//            //}
//            //.frame(maxWidth: .infinity)
//            //.background(Color.gray)
//
//
//        }
//        .navigationBarTitle("Crypto Dashboard") // define navigation view title
        
    }
    
}
