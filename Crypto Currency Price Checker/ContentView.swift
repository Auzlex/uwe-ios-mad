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
        
        NavigationView {
            ScrollView {
                VStack {
                    //Color.black.edgesIgnoringSafeArea(.all)
                    //Text("Sample Text")
                    //    .padding()
                    //.frame(maxWidth: .infinity)

//                    ForEach((1...15), id: \.self) { _ in
//                        HStack
//                        {
//                            Text("SAMPLE BTC")
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
//                    }

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
                //.padding(.top, UIApplication.shared.windows.first!.safeAreaInsets.top )
                //.navigationViewStyle(StackNavigationViewStyle())
                //.background(Color.black.edgesIgnoringSafeArea(.all))
                .preferredColorScheme(.dark)

                /*.frame(
                      minWidth: 0,
                      maxWidth: .infinity,
                      minHeight: 0,
                      maxHeight: .infinity,
                      alignment: .topLeading
                    )*/
            }
            .navigationTitle("Sample Text")
            
            // edge: .bottom, alignment: .trailing
            // edge: .bottom, alignment: .center, spacing: 0
            .safeAreaInset(edge: .bottom, alignment: .trailing, spacing: 0) {

                /*Color.clear
                    .frame(height: 20)
                    .background(Material.bar)*/
                Text("Outside Safe Area")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Material.bar)
//                Button {
//                    print("Show help")
//                } label: {
//                    Image(systemName: "info.circle.fill")
//                        .font(.largeTitle)
//                        .symbolRenderingMode(.multicolor)
//                        .padding(.trailing)
//                }
//                .accessibilityLabel("Show help")


            }
        }
    }
    
    
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
