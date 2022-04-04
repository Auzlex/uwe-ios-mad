//
//  Favourites.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 04/04/2022.
//

import Foundation

class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var symbols: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        // load our saved data

        // still here? Use an empty array
        symbols = []
    }

    // returns true if our set contains this resort
    func contains(_ apisymbol: APISymbol) -> Bool {
        symbols.contains(apisymbol.symbol)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ apisymbol: APISymbol) {
        objectWillChange.send()
        symbols.insert(apisymbol.symbol)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ apisymbol: APISymbol) {
        objectWillChange.send()
        symbols.remove(apisymbol.symbol)
        save()
    }

    func save() {
        // write out our data
    }
}
