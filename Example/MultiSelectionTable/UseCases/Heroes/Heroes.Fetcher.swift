//
//  Heroes.Fetcher.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 09/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Heroes {
    
    struct Fetcher {
        
        static func fetch(named name: String? = nil, got: @escaping ([Hero]) -> ()) {
            let page = 0
            let url = buildUrl(with: page, and: name)
            Network.get(from: url) { result in
                switch result {
                case .success(let json):
                    let nsJson = json as NSDictionary
                    let dicCharacters = nsJson.value(forKeyPath: "data.results") as! [[String : Any]]
                    let heroes = dicCharacters.flatMap { Hero(dictionary: $0) }
                    got(heroes)
                case .failure(_):
                    //We should really propagate the Result the the caller
                    return got([])
                }
            }
        }
        
        static let ts = "1"
        static let pub = MarvelApiConfiguration.instance.publicKey
        static let priv = MarvelApiConfiguration.instance.secretKey
        static let charactersUrl = "http://gateway.marvel.com:80/v1/public/characters"
        
        static var hash : String {
            return "\(ts)\(priv)\(pub)".md5ed
        }
        
        fileprivate static func buildUrl(with page: Int, and name: String? = nil) -> URL {
            let limit = 25
            var urlStr = "\(charactersUrl)?limit=\(limit)&offset=\(page * limit)&apikey=\(pub)&ts=1&hash=\(hash)"
            if let name = name,
                !name.characters.isEmpty {
                urlStr.append("&nameStartsWith=\(name)")
                urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            return URL(string: urlStr)!
        }
    }
}

fileprivate extension String  {
    var md5ed: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
}
