//
//  MultiSelectionTableDelegate.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 01/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

public protocol MultiSelectionTableDelegate : class {
    
    func paint(_ cell: UITableViewCell, for indexPath: IndexPath, with object: Any)
    
}

