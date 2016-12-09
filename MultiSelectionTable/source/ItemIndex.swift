//
//  ItemIndex.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 01/12/16.
//

internal struct ItemIndex<T : Equatable> : Equatable {
    
    let item: T
    var index: Int
    
    static func ==(lhs: ItemIndex, rhs: ItemIndex) -> Bool {
        return lhs.item == rhs.item
    }
}
