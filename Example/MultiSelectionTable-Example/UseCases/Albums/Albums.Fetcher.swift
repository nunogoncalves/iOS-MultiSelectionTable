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
        
        static var url: URL {
            return URL(string: "https://dl.dropboxusercontent.com/u/2001692/Development/JSONs/albums.json")!
        }

        static func fetch(got: @escaping ([Album]) -> ()) {
            
            Network.get(from: url) { result in
                switch result {
                case .success(let json):
                    if let dicAlbums = json["albums"] as? [[String : Any]] {
                        let albums = dicAlbums.flatMap { Album(dictionary: $0) }
                        got(albums)
                    } else {
                        //We should really propagate the Result the the caller
                        got([])
                    }
                case .failure(_):
                    return got([])
                }
            }
        }
    }
}
