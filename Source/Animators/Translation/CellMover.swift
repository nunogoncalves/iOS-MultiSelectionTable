//
//  CellMover.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 09/12/16.
//
//

import UIKit

public class CellMover : CellTransitionAnimator {
    
    public func selectionTransition(in containerView: UIView,
                                    fromTableView: UITableView,
                                    fromIndexPath: IndexPath,
                                    toTableView: UITableView,
                                    toIndexPath: IndexPath) {
        
        toTableView.insertRows(at: [toIndexPath], with: .top)
        
        guard let newCellAdded = newlyAddedCell(in: toTableView, with: toIndexPath) else { return }
        newCellAdded.contentView.isHidden = true
        
        guard let cellToDelete = fromTableView.cellForRow(at: fromIndexPath) else { return }
        
        let newCellConvertedFrame = newCellAdded.convert(newCellAdded.contentView.frame, to: containerView)
        
        if let movingCell = cellToDelete.contentView.snapshotView(afterScreenUpdates: false) {
            cellToDelete.contentView.isHidden = true
            containerView.addSubview(movingCell)
            movingCell.frame = fromTableView.convert(cellToDelete.frame, to: containerView)
            
            fromTableView.deleteRows(at: [fromIndexPath], with: .top)
            
            UIView.animate(withDuration: 0.4, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                movingCell.removeFromSuperview()
                newCellAdded.contentView.isHidden = false
                cellToDelete.contentView.isHidden = false
            })
        }
        
    }
    
    public func unselectionTransition(in containerView: UIView,
                                      fromTableView: UITableView,
                                      fromIndexPath: IndexPath,
                                      toTableView: UITableView,
                                      toIndexPath: IndexPath) {
        
        toTableView.insertRows(at: [toIndexPath], with: .bottom)
        
        guard let newCellAdded = newlyAddedCell(in: toTableView, with: toIndexPath) else { return }
        newCellAdded.contentView.isHidden = true
        
        let newCellConvertedFrame = newCellAdded.convert(newCellAdded.contentView.frame, to: containerView)
        
        guard let cellToDelete = fromTableView.cellForRow(at: fromIndexPath) else { return }
        
        if let movingCell = cellToDelete.contentView.snapshotView(afterScreenUpdates: false) {
            cellToDelete.contentView.isHidden = true
            containerView.addSubview(movingCell)
            movingCell.frame = fromTableView.convert(cellToDelete.frame, to: containerView)
            
            fromTableView.deleteRows(at: [fromIndexPath], with: .top)
            
            UIView.animate(withDuration: 0.4, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                movingCell.removeFromSuperview()
                newCellAdded.contentView.isHidden = false
            })
        }
    }
    
    private func newlyAddedCell(in tableView: UITableView, with indexPath: IndexPath) -> UITableViewCell? {
        return tableView.cellForRow(at: indexPath) ?? tableView.visibleCells.last
    }
}
