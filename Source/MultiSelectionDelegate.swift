//
//  MultiSelectionTableDelegate.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 01/12/16.
//

import UIKit

public protocol MultiSelectionTableDelegate : class {
    
    func paint(_ cell: UITableViewCell, for indexPath: IndexPath, with object: Any)
    
}

