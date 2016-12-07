//
//  MultiSelectionDataSource.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 04/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class MultiSelectionDataSource<T : Equatable> : DataSource {
    
    let multiSelectionTableView: MultiSelectionTableView!
    
    weak var delegate: MultiSelectionTableDelegate?
    
    fileprivate var allItemsIndexes: [ItemIndex<T>] = []
    var allItems: [T] = [] {
        didSet {
            mapToItemIndexesAndUpdateOriginSelectedIndexesIfNecessary()
            multiSelectionTableView.reloadAllItemsTable()
        }
    }
    
    var allItemsCount: Int {
        return allItemsIndexes.count
    }
    
    fileprivate var selectedItemsIndexes: [ItemIndex<T>] = []
    var selectedItems: [T] {
        return selectedItemsIndexes.map { $0.item }
    }

    var selectedItemsCount: Int {
        return selectedItemsIndexes.count
    }
    
    private func mapToItemIndexesAndUpdateOriginSelectedIndexesIfNecessary() {
        let _selectedItems = selectedItemsIndexes.map{ $0.item }
        allItemsIndexes = allItems.enumerated().flatMap { index, item in
            if let indexOfItem = _selectedItems.index(of: item) {
                selectedItemsIndexes[indexOfItem].index = index
                return nil
            }
            return ItemIndex(item: item, index: index)
        }
    }
    
    init(multiSelectionTableView: MultiSelectionTableView) {
        self.multiSelectionTableView = multiSelectionTableView
    }
    
    fileprivate var cellReuseId = "Cell"
    func register(nib: UINib, for cellReuseIdentifier: String) {
        cellReuseId = cellReuseIdentifier
        multiSelectionTableView.register(nib: nib, for: cellReuseId)
    }
    
    func selectedItem(at index: Int) {
        let item = allItemsIndexes.remove(at: index)
        selectedItemsIndexes.append(item)
        
        multiSelectionTableView.addToSelectedItemsTable(at: index)
    }
    
    func unselectedItem(at index: Int) {
    
        let item = selectedItemsIndexes.remove(at: index)
        
        guard let indexToAdd = findIndexToPutBack(item, in: allItemsIndexes) else {
            multiSelectionTableView.removeFromSelected(at: index)
            return
        }
        
        allItemsIndexes.insert(item, at: indexToAdd)
        
        multiSelectionTableView.putBackInAllItemsTable(at: indexToAdd, selectedItemAt: index)
                
        if selectedItemsIndexes.isEmpty {
            multiSelectionTableView.displayAllItems()
        }
        
    }
    
    private func findIndexToPutBack(_ item: ItemIndex<T>, in list: [ItemIndex<T>]) -> Int? {
        guard allItems.contains(item.item) else { return nil }
        
        for (index, iteratedItemIndex) in list.enumerated() {
            if iteratedItemIndex.index >= item.index {
                return index
            }
        }
        
        return item.index
    }

    func cell(for indexPath: IndexPath, inAllItemsTable tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        let item = allItemsIndexes[indexPath.row]
        delegate?.paint(cell, for: indexPath, with: item.item)
        
        return cell
    }
    
    func cell(for indexPath: IndexPath, inSelectedItemsTable tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        let item = selectedItemsIndexes[indexPath.row]
        delegate?.paint(cell, for: indexPath, with: item.item)
        return cell
    }
    
}
