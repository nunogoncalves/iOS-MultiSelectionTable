//
//  DataSource.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 04/12/16.
//

import UIKit

public protocol DataSource : class {
    
    var allItemsCount: Int { get }
    var selectedItemsCount: Int { get }
    func cell(for indexPath: IndexPath, inAllItemsTable tableView: UITableView) -> UITableViewCell
    func cell(for indexPath: IndexPath, inSelectedItemsTable tableView: UITableView) -> UITableViewCell
    
    func unselectedItem(at index: Int)
    func selectedItem(at index: Int)

}
