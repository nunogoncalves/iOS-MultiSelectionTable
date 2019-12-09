//
//  Album+DictInit.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 10/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Album {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let year = dictionary["year"] as? Int,
            let coverImageName = dictionary["coverImageUrl"] as? String,
            let bandDic = dictionary["band"] as? [String: Any],
            let bandName = bandDic["name"] as? String
        else {
                return nil
        }
        
        self.band = Band(name: bandName)
        self.name = name
        self.coverImageName = coverImageName
        print(coverImageName)
        self.year = year
    }
    
}
