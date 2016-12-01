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
    let cover: UIImage
    
    static func ==(left: Album, right: Album) -> Bool {
        return left.name == right.name &&
            left.cover == right.cover &&
            left.band == right.band
    }
    
}
