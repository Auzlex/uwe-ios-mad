//
//  DashboardView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 06/05/2022.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: CCPCViewModel
    @EnvironmentObject var favorites: Favorites
    
    init(viewModel: CCPCViewModel)
    {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        // Vstack
        VStack(alignment: .leading) {
        
            //ScrollView{
                
            // NOTE: Removing these 2 vstacks fixes the safe area being ignored????
//                VStack(spacing: 20) {
//                    Text("Top Cryptos")
//                    Text("IMPLEMENT_TOP_CRYPTOS")
//                }
//                .frame(maxWidth: .infinity)
//
//                VStack(spacing: 20) {
//                    Text("Gainers & Losers")
//                    Text("IMPLEMENT_GAINERS_&_LOOSERS")
//                }
//                .frame(maxWidth: .infinity)

                VStack(spacing: 20) {
                    Text("News")
                    ScrollView {
                        ForEach((1...10), id: \.self) { i in
                            HStack {
                                AsyncImage(
                                    url:URL(string:"https://ichef.bbci.co.uk/news/1024/branded_news/1257B/production/_118713157_gettyimages-897291236.jpg"),
                                    content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 100)
                                    },
                                    placeholder: {
                                        //ProgressView()
                                        Image("nosign")
                                    }
                                )
                                .cornerRadius(10)
                                //.padding(.all, 5)
                                //.frame(maxWidth: 100, maxHeight: 100)
                                .frame(width: 100, height: 100)
                                //.aspectRatio(contentMode: .fit)
                                    
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut quis nunc in ligula pretium varius. Integer velit nulla, posuere in tempor vel, viverra vel ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce interdum in sapien sit amet pharetra. Sed sed risus sed diam commodo tristique et non est. Aenean nec dapibus quam. Vivamus convallis ipsum sed arcu egestas mattis placerat ut elit.")
                                .padding()
                                .font(.system(size: 12))
                                .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(Color.gray, lineWidth: 1)
                                        )
                            }
                        }
                    }
                }
                //.frame(maxWidth: .infinity)//, maxHeight: 400)
                //.background(Color.gray)
                
            //}
            //.frame(maxWidth: .infinity)
            //.background(Color.gray)
            
            
        }
        .navigationBarTitle("Crypto Dashboard") // define navigation view title
        
    }
    
}
