//
//  Hero+DictInit.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 10/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Hero {
    
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let thumb = dictionary["thumbnail"] as? [String : String],
            let thumbPath = thumb["path"],
            let thumbExtension = thumb["extension"],
            let url = URL(string: "\(thumbPath).\(thumbExtension)")
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.imageURL = url
    }

}
