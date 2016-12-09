//
//  CellTransitionable.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 09/12/16.
//
//

public protocol CellTransitionable {
    func selectionTransition(in containerView: UIView,
                             fromTableView: UITableView,
                             fromIndexPath: IndexPath,
                             toTableView: UITableView,
                             toIndexPath: IndexPath)
    
    func unselectionTransition(in containerView: UIView,
                               fromTableView: UITableView,
                               fromIndexPath: IndexPath,
                               toTableView: UITableView,
                               toIndexPath: IndexPath)
}
