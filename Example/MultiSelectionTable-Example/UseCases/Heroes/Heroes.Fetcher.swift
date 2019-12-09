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
        
        static func fetch(named name: String? = nil, in page: Int = 0, got: @escaping (HeroesList) -> ()) {
            let url = buildUrl(with: page, and: name)
            Network.get(from: url) { result in
                switch result {
                case .success(let json):
                    guard let dataDic = json["data"] as? [String : Any] else {
                        return got(HeroesList(heroes: [],
                                              totalCount: 0,
                                              currentPage: 0,
                                              totalPages: 0))
                    }
                    
                    let totalCount = dataDic["total"] as? Int ?? 0
                    let offset = dataDic["offset"] as? Int ?? 0
                    let limit = dataDic["limit"] as? Int ?? 0

                    let totalPages = limit == 0 ? 0 : Int(ceil(Double(totalCount / limit)))
                    let currentPage = totalCount == 0 ? 0 : Int(ceil(Double(totalPages) * Double(offset) / Double(totalCount)))

                    let dicCharacters = dataDic["results"] as! [[String : Any]]
                    let heroes = dicCharacters.flatMap { Hero(dictionary: $0) }
                    
                    let heroesList = HeroesList(heroes: heroes,
                                                totalCount: totalCount,
                                                currentPage: currentPage,
                                                totalPages: totalPages)
                    got(heroesList)
                case .failure(_):
                    //We should really propagate the Result the the caller
                    return got(HeroesList(heroes: [],
                                          totalCount: 0,
                                          currentPage: 0,
                                          totalPages: 0))
                }
            }
        }
        
        static let ts = "1"
        static let pub = "ab781b828ce0d61d8d053bde7d8c3fde"
        static let priv = "f9490b9557c2e8e7c52b72a632898b63658dcf5b"
        static let charactersUrl = "http://gateway.marvel.com:80/v1/public/characters"
        
        static var hash : String {
            return "\(ts)\(priv)\(pub)".md5ed
        }
        
        fileprivate static func buildUrl(with page: Int, and name: String? = nil) -> URL {
            let limit = 25
            var urlStr = "\(charactersUrl)?limit=\(limit)&offset=\(page * limit)&apikey=\(pub)&ts=1&hash=\(hash)"
            if let name = name,
                !name.isEmpty {
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
        
        result.deallocate()
        
        return String(format: hash as String)
    }
}
