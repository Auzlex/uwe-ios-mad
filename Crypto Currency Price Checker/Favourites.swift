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
    func contains(_ apisymbol: String) -> Bool {
        symbols.contains(apisymbol)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ apisymbol: String) {
        objectWillChange.send()
        symbols.insert(apisymbol)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ apisymbol: String) {
        objectWillChange.send()
        symbols.remove(apisymbol)
        save()
    }

    func save() {
        // write out our data
    }
}
