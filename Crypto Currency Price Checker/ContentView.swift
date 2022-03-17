//
//  ContentView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 11/02/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: CCPCViewModel
    
    var body: some View {
        //Color.black.edgesIgnoringSafeArea(.all)
        //.backgroundColor(Color.black)
        ScrollView {
            
            VStack {
                //Color.black.edgesIgnoringSafeArea(.all)
                //Text("Sample Text")
                //    .padding()
                //.frame(maxWidth: .infinity)
                
                ForEach(viewModel.symbols, id: \.self) { symbol in
                    HStack
                    {
                        Text(symbol.symbol)
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
                    //.border(Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255), width: 1)
                    
                }
            }
            .onAppear(perform: viewModel.refresh)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding([.leading, .trailing], 20)
            //Color.black.edgesIgnoringSafeArea(.all)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
            
            /*.frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )*/
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel:CCPCViewModel(cryptoInformationService: CryptoInformationService()))
    }
}
