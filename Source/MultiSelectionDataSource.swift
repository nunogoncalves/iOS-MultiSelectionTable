//
//  MultiSelectionDataSource.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 04/12/16.
//

import UIKit

final public class MultiSelectionDataSource<T : Equatable> : DataSource {
    
    fileprivate let multiSelectionTableView: MultiSelectionTableView!
    
    public weak var delegate: MultiSelectionTableDelegate?
    
    fileprivate var allItemsIndexes: [ItemIndex<T>] = []
    public var allItems: [T] = [] {
        didSet {
            mapToItemIndexesAndUpdateOriginSelectedIndexesIfNecessary()
            multiSelectionTableView.reloadAllItemsTable()
        }
    }
    
    public var allItemsCount: Int {
        return allItemsIndexes.count
    }
    
    fileprivate var selectedItemsIndexes: [ItemIndex<T>] = []
    public var selectedItems: [T] {
        return selectedItemsIndexes.map { $0.item }
    }

    public var selectedItemsCount: Int {
        return selectedItemsIndexes.count
    }
    
    private func mapToItemIndexesAndUpdateOriginSelectedIndexesIfNecessary() {
        let _selectedItems = selectedItemsIndexes.map{ $0.item }
        allItemsIndexes = allItems.enumerated().compactMap { index, item in
            if let indexOfItem = _selectedItems.firstIndex(of: item) {
                selectedItemsIndexes[indexOfItem].index = index
                return nil
            }
            return ItemIndex(item: item, index: index)
        }
    }
    
    public init(multiSelectionTableView: MultiSelectionTableView) {
        self.multiSelectionTableView = multiSelectionTableView
    }
    
    fileprivate var cellReuseId = "Cell"
    public func register(nib: UINib, for cellReuseIdentifier: String) {
        cellReuseId = cellReuseIdentifier
        multiSelectionTableView.register(nib: nib, for: cellReuseId)
    }
    
    public func register(anyClass: AnyClass?, for cellReuseIdentifier: String) {
        cellReuseId = cellReuseIdentifier
        multiSelectionTableView.register(anyClass: anyClass, for: cellReuseId)
    }
    
    public func selectedItem(at index: Int) {
        let item = allItemsIndexes.remove(at: index)
        selectedItemsIndexes.append(item)
        
        multiSelectionTableView.addToSelectedItemsTable(at: index)
    }
    
    public func unselectedItem(at index: Int) {
    
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

    public func cell(for indexPath: IndexPath, inAllItemsTable tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        let item = allItemsIndexes[indexPath.row]
        delegate?.paint(cell, at: indexPath, in: tableView, with: item.item)
        
        return cell
    }
    
    public func cell(for indexPath: IndexPath, inSelectedItemsTable tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        let item = selectedItemsIndexes[indexPath.row]
        delegate?.paint(cell, at: indexPath, in: tableView, with: item.item)
        return cell
    }
    
}
