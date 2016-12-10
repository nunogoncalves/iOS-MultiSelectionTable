//
//  Album.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 29/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

struct Album : Equatable {
    
    let band: Band
    let name: String
    let coverImageURL: URL
    let year: Int
    
    static func ==(left: Album, right: Album) -> Bool {
        return left.name == right.name &&
            left.coverImageURL == right.coverImageURL &&
            left.band == right.band
    }
 
    static func all(finished: @escaping ([Album]) -> ()) {
        Albums.Fetcher.fetch(got: finished)
    }
}
