//
//  Hero.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 09/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Hero : Equatable {
    let id: Int
    let name: String
    let imageURL: URL
 
    static func all(named name: String? = nil, in page: Int, finished: @escaping (HeroesList) -> ()) {
        Heroes.Fetcher.fetch(named: name, in: page, got: finished)
    }
    
    static func ==(leftHero: Hero, rightHero: Hero) -> Bool {
        return leftHero.id == rightHero.id && leftHero.name == rightHero.name
    }
}
