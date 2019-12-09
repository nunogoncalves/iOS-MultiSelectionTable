//
//  Albums.Fetcher.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 10/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Albums {
    
    struct Fetcher {

        static func fetch(got: @escaping ([Album]) -> ()) {

            guard let path = Bundle.main.path(forResource: "albums", ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            else { return }

            if let dicAlbums = json["albums"] as? [[String : Any]] {
                let albums = dicAlbums.compactMap { Album(dictionary: $0) }
                got(albums)
            } else {
                //We should really propagate the Result the the caller
                got([])
            }
        }
    }
}
