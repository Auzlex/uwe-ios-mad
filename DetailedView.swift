//
//  DetailedView.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 18/03/2022.
//

import SwiftUI

struct DetailView_Previews: PreviewProvider {
    @ObservedObject var viewModel = CCPCViewModel(cryptoInformationService: CryptoInformationService())
    static var previews: some View {
        DetailView(symbol: viewModel.symbols.first ?? default APISymbol(symbol: "BTC", status: "", baseAsset: "", baseAssetPrecision: 0, quoteAsset: "", quotePrecision: 0, quoteAssetPrecision: 0, baseCommissionPrecision: 0, quoteCommissionPrecision: 0))
    }
}

struct DetailView: View {
    let symbol: APISymbol
    var body: some View {
        Form {
            Image(symbol.baseAsset)
                .clipShape(Circle())
            HStack{
                Text("phone")
                Spacer()
                Text("No")
                    .foregroundColor(.gray)
                    .font(.callout)
            }
        }
    }
}
