//
//  MarvelApiConfiguration.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 09/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct MarvelApiConfiguration {
    
    //IMPORTANT: - Add Secret keys MarvelSecretKeys.plist file at ../../../../Secrets/MarvelSecretKeys.plist
    
    static let instance = MarvelApiConfiguration()
    
    let publicKey: String
    let secretKey: String
    
    private init() {
        if let pListPath = Bundle.main.path(forResource: "MarvelSecretKeys", ofType: "plist"),
            let content = NSDictionary(contentsOfFile: pListPath) {
            publicKey = content["PublicKey"] as! String
            secretKey = content["SecretKey"] as! String
        } else {
            fatalError("MarvelSecretKeys.plist. ADD IT AT: ../../../iOS-MultiSelectionTableSecrets/MarvelSecretKeys.plist")
        }
    }
}
