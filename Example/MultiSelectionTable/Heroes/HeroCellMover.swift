//
//  HeroCellMover.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 09/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit
import MultiSelectionTableView

class HeroCellMover : CellTransitionAnimator {
    
    func selectionTransition(in containerView: UIView,
                             fromTableView: UITableView,
                             fromIndexPath: IndexPath,
                             toTableView: UITableView,
                             toIndexPath: IndexPath) {
        
        toTableView.insertRows(at: [toIndexPath], with: .left)
        fromTableView.deleteRows(at: [fromIndexPath], with: .right)
    }
    
    func unselectionTransition(in containerView: UIView,
                               fromTableView: UITableView,
                               fromIndexPath: IndexPath,
                               toTableView: UITableView,
                               toIndexPath: IndexPath) {
        
        toTableView.insertRows(at: [toIndexPath], with: .right)
        fromTableView.deleteRows(at: [fromIndexPath], with: .left)
    }
}
