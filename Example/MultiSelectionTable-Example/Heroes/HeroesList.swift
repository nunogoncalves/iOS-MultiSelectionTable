//
//  HeroesGroup.swift
//  MultiSelectionTable-Example
//
//  Created by Nuno Gonçalves on 16/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct HeroesList {
    static let emptyHeroesList = HeroesList(heroes: [], totalCount: 0, currentPage: 0, totalPages: 0)
    
    let heroes: [Hero]
    
    let totalCount: Int
    let currentPage: Int
    let totalPages: Int

    var hasMorePages: Bool {
        return currentPage < totalPages
    }

    var isFirstPage: Bool {
        return currentPage == 0
    }
    
}
