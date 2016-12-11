//
//  Network.Get.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 11/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Network {
    
    fileprivate static let urlSession = URLSession(configuration: .default)
    
    typealias JSONDictionary = [String : Any]
    
    static func get(from url: URL, got result: @escaping (Result<JSONDictionary>) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let task = urlSession.dataTask(with: url, completionHandler: { data, response, error in
                if let data = data {
                    do {
                        let json = try dictionary(from: data)
                        DispatchQueue.main.async {
                            result(.success(json))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            result(.failure(.parse))
                        }

                    }
                } else {
                    DispatchQueue.main.async {
                        result(.failure(.data))
                    }
                }
            })
            task.resume()
        }
    }
    
    private static func dictionary(from data: Data) throws -> JSONDictionary {
        let dataJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        if let dataDictionary = dataJSON as? JSONDictionary {
            return dataDictionary
        }
        throw NetworkError.parse
    }
}
