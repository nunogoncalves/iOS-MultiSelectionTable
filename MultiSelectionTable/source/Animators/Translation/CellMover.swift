//
//  CellMover.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 09/12/16.
//
//

public class CellMover : CellTransitionable {
    
    public func selectionTransition(in containerView: UIView,
                                    fromTableView: UITableView,
                                    fromIndexPath: IndexPath,
                                    toTableView: UITableView,
                                    toIndexPath: IndexPath) {
        
        toTableView.insertRows(at: [toIndexPath], with: .top)
        
        var _newCellAdded: UITableViewCell?
        
        if let cell = toTableView.cellForRow(at: toIndexPath) {
            _newCellAdded = cell
        } else if let cell = toTableView.visibleCells.last {
            _newCellAdded = cell
        }
        
        guard let newCellAdded = _newCellAdded else { return }
        
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
                cellToDelete.contentView.isHidden = false
            })
        }
        
    }
    
    public func unselectionTransition(in containerView: UIView,
                                      fromTableView: UITableView,
                                      fromIndexPath: IndexPath,
                                      toTableView: UITableView,
                                      toIndexPath: IndexPath) {
        
        let newIndexPath = toIndexPath
        let allItemsTable = toTableView
        
        let indexPath = fromIndexPath
        let selectedItemsTable = fromTableView
        
        allItemsTable.insertRows(at: [newIndexPath], with: .bottom)
        
        var _newCellAdded: UITableViewCell?
        
        if let cell = allItemsTable.cellForRow(at: newIndexPath) {
            _newCellAdded = cell
        } else if let cell = allItemsTable.visibleCells.last {
            _newCellAdded = cell
        }
        
        guard let newCellAdded = _newCellAdded else { return }
        
        newCellAdded.contentView.isHidden = true
        let newCellConvertedFrame = newCellAdded.convert(newCellAdded.contentView.frame, to: containerView)
        
        guard let cellToDelete = selectedItemsTable.cellForRow(at: indexPath) else { return }
        
        if let movingCell = cellToDelete.contentView.snapshotView(afterScreenUpdates: false) {
            cellToDelete.contentView.isHidden = true
            containerView.addSubview(movingCell)
            movingCell.frame = selectedItemsTable.convert(cellToDelete.frame, to: containerView)
            
            selectedItemsTable.deleteRows(at: [indexPath], with: .top)
            
            UIView.animate(withDuration: 0.4, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                movingCell.removeFromSuperview()
                newCellAdded.contentView.isHidden = false
            })
        }
    }
}
