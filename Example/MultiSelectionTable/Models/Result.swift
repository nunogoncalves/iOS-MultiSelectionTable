//
//  Result.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 11/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

enum Result<T> {
    case success(T)
    case failure(NetworkError)
}
