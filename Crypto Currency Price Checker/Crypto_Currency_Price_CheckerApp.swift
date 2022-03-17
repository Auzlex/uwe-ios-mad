//
//  Crypto_Currency_Price_CheckerApp.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 11/02/2022.
//

import SwiftUI

@main
struct Crypto_Currency_Price_CheckerApp: App {
    var body: some Scene {
        WindowGroup {
            let cryptoInformationService = CryptoInformationService()
            let viewModel = CCPCViewModel(cryptoInformationService: CryptoInformationService())
            ContentView(viewModel: viewModel)
        }
    }
}
