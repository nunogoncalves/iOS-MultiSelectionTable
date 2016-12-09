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
        
        static func fetch(got: @escaping ([Hero]) -> ()) {
            DispatchQueue.global(qos: .userInteractive).async {
                let urlSession = URLSession(configuration: URLSessionConfiguration.default)
                let task = urlSession.dataTask(with: buildUrl(0), completionHandler: { (data, response, error) in
                    if let data = data {
                        let characters = convertDataIntoCharacters(data)
                        DispatchQueue.main.async {
                            got(characters)
                        }
                    } else {
                        print("error: \(error)")
                    }
                })
                task.resume()
            }
        }
        
        static let ts = "1"
        static let pub = MarvelApiConfiguration.instance.publicKey
        static let priv = MarvelApiConfiguration.instance.secretKey
        static let charactersUrl = "http://gateway.marvel.com:80/v1/public/characters"
        
        static var hash : String {
            return "\(ts)\(priv)\(pub)".md5
        }
        
        fileprivate static func buildUrl(_ page: Int) -> URL {
            let limit = 25
            return URL(string: "\(charactersUrl)?limit=\(limit)&offset=\(page * limit)&apikey=\(pub)&ts=1&hash=\(hash)")!
        }
        
        
        static func convertDataIntoCharacters(_ data: Data) -> [Hero] {
            do {
                let dataJSON = try JSONSerialization
                    .jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                let dataDictionary = dataJSON as! NSDictionary
                let dicCharacters = dataDictionary.value(forKeyPath: "data.results") as! [[String : Any]]
                var chars: [Hero] = []
                
                for char in dicCharacters {
                    guard let id = char["id"] as? Int,
                        let name = char["name"] as? String,
                        let thumb = char["thumbnail"] as? [String : String],
                        let thumbPath = thumb["path"],
                        let thumbExtension = thumb["extension"],
                        let url = URL(string: "\(thumbPath).\(thumbExtension)")
                    else {
                        continue
                    }
                    
                    let hero = Hero(id: id,
                                    name: name,
                                    imageURL: url)
                    chars.append(hero)
                }
                return chars
                
            } catch {
                return []
            }
        }
    }

    
}

fileprivate extension String  {
    var md5: String! {
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

