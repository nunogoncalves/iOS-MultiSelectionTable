//
//  Band.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 29/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

struct Band: Equatable {
    
    let name: String
    
    static func ==(left: Band, right: Band) -> Bool {
        return left.name == right.name
    }
    
}
