//
//  MultiSelectionTableDelegate.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 01/12/16.
//

import UIKit

public protocol MultiSelectionTableDelegate : class {
    
    func paint(_ cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView, with object: Any)
    
}

