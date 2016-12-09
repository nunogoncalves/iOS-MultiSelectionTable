//
//  MarvelApiConfiguration.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 09/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct MarvelApiConfiguration {
    
    //IMPORTANT: - Add Secret keys MarlvelSecretKeys.plist file at ../../../../Secrets/MarlvelSecretKeys.plist
    
    static let instance = MarvelApiConfiguration()
    
    let publicKey: String
    let secretKey: String
    
    private init() {
        if let pListPath = Bundle.main.path(forResource: "MarlvelSecretKeys", ofType: "plist"),
            let content = NSDictionary(contentsOfFile: pListPath) {
            publicKey = content["PublicKey"] as! String
            secretKey = content["SecretKey"] as! String
        } else {
            publicKey = "MISSING_PUBLIC_KEY ADD IT AT: ../../../../Secrets/MarlvelSecretKeys.plist"
            secretKey = "MISSING_SECRET_KEY ADD IT AT ../../../../Secrets/MarlvelSecretKeys.plist"
        }
    }
}
