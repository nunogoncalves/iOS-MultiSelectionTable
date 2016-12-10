//
//  Albums.Fetcher.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 10/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Albums {
    
    struct Fetcher {
        
        static var url: URL {
            return URL(string: "https://dl.dropboxusercontent.com/u/2001692/Development/JSONs/albuns.json")!
        }

        static func fetch(got: @escaping ([Album]) -> ()) {
            DispatchQueue.global(qos: .userInteractive).async {
                let urlSession = URLSession(configuration: URLSessionConfiguration.default)
                let task = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data {
                        let allAlbums = albums(from: data)
                        DispatchQueue.main.async {
                            got(allAlbums)
                        }
                    } else {
                        print("error: \(error)")
                    }
                })
                task.resume()
            }
        }
        
        static func albums(from data: Data) -> [Album] {
            do {
                let dataJSON = try JSONSerialization
                    .jsonObject(with: data, options: .mutableContainers)
                let dataDictionary = dataJSON as! NSDictionary
                let dicAlbums = dataDictionary.value(forKeyPath: "albuns") as! [[String : Any]]
                
                return dicAlbums.flatMap { Album(dictionary: $0) }
                
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

