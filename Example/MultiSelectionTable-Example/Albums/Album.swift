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
    let coverImageName: String
    let year: Int

    static func all(finished: @escaping ([Album]) -> ()) {
        Albums.Fetcher.fetch(got: finished)
    }
}
