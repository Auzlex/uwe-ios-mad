//
//  Favourites.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 04/04/2022.
//

import Foundation

class SavedAsset: Identifiable, Codable {
    var id = UUID();
    var asset_name = "";

    init(asset_name: String) {
        self.asset_name = asset_name;
    }
}

class Favorites: ObservableObject {
    
    @Published var favourited_assets: [SavedAsset]
    
    // the actual resorts the user has favorited
    private var symbols: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    func load_user_data()
    {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([SavedAsset].self, from: data) {
                self.favourited_assets = decoded
                
                // convert all the asset_name within array favourited_assets to a Set of Strings
                symbols = Set(favourited_assets.map { $0.asset_name })
                
                return
            }
        }
    }

    func save_user_data() {

        // for every symbol in symbols
        for symbol in symbols {
            // check to see if we already have a resort stored with this symbol
            if let asset = favourited_assets.first(where: { $0.asset_name == symbol }) {
                // if we do, update the stored version
                asset.asset_name = symbol
            } else {
                // otherwise, this is a new symbol and needs to be stored
                favourited_assets.append(SavedAsset(asset_name: symbol))
            }
        }

        // write the array to UserDefaults
        if let encoded = try? JSONEncoder().encode(favourited_assets) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
    }
    
    init() {
        
        symbols = []
        
        // initialize empty array
        favourited_assets = []

        // load our saved data
        load_user_data()
    }

    // returns true if our set contains this resort
    func contains(_ apisymbol: String) -> Bool {
        symbols.contains(apisymbol)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ apisymbol: String) {
        objectWillChange.send()
        symbols.insert(apisymbol)
        save_user_data()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ apisymbol: String) {
        objectWillChange.send()
        symbols.remove(apisymbol)
        save_user_data()
    }

}
