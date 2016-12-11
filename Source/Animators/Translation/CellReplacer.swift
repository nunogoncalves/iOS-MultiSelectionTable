//
//  CellReplacer.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 09/12/16.
//
//

import UIKit

public class CellReplacer : CellTransitionAnimator {
    
    public init() {}
    
    public func selectionTransition(in containerView: UIView,
                                    fromTableView: UITableView,
                                    fromIndexPath: IndexPath,
                                    toTableView: UITableView,
                                    toIndexPath: IndexPath) {
        
        toTableView.insertRows(at: [toIndexPath], with: .left)
        fromTableView.deleteRows(at: [fromIndexPath], with: .right)
    }
    
    public func unselectionTransition(in containerView: UIView,
                                      fromTableView: UITableView,
                                      fromIndexPath: IndexPath,
                                      toTableView: UITableView,
                                      toIndexPath: IndexPath) {
        toTableView.insertRows(at: [toIndexPath], with: .right)
        fromTableView.deleteRows(at: [fromIndexPath], with: .left)
    }
}
