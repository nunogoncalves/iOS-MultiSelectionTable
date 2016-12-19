//
//  CellFlyerAnimator.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 09/12/16.
//
//

import MultiSelectionTableView

public class SuperManAnimator : CellTransitionAnimator {
    
    public init() {}
    
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
        (cellToDelete as? HeroCell)?.bottomLine.isHidden = true

        if let movingCell = cellToDelete.contentView.snapshotView(afterScreenUpdates: true) {
            let viewToHide = UIView(frame: CGRect(x: 0, y: 0, width: movingCell.frame.width, height: movingCell.frame.height))
            movingCell.addSubview(viewToHide)
            let superman = UIImageView(image: #imageLiteral(resourceName: "SupermanFlyRight"))
            superman.frame = CGRect(x: -90, y: movingCell.frame.midY - 20, width: 100, height: 40)
            movingCell.addSubview(superman)
            
            cellToDelete.contentView.isHidden = true
            containerView.addSubview(movingCell)
            movingCell.frame = fromTableView.convert(cellToDelete.frame, to: containerView)
            
            fromTableView.deleteRows(at: [fromIndexPath], with: .top)
            
            UIView.animate(withDuration: 1, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                newCellAdded.contentView.isHidden = false
                cellToDelete.contentView.isHidden = false
                UIView.animate(withDuration: 1,
                               animations: {
                                 superman.frame = superman.frame.offsetBy(dx: movingCell.frame.width + superman.frame.width,
                                                                          dy: 0)
                               },
                               completion: { _ in
                                movingCell.removeFromSuperview()
                               })
                viewToHide.isHidden = true
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
            let viewToHide = UIView(frame: CGRect(x: 0, y: 0, width: movingCell.frame.width, height: movingCell.frame.height))
            movingCell.addSubview(viewToHide)
            let superman = UIImageView(image: #imageLiteral(resourceName: "SupermanFlyLeft"))
            superman.frame = CGRect(x: movingCell.frame.width - 5, y: movingCell.frame.midY - 20, width: 100, height: 40)
            movingCell.addSubview(superman)
            
            cellToDelete.contentView.isHidden = true
            containerView.addSubview(movingCell)
            movingCell.frame = selectedItemsTable.convert(cellToDelete.frame, to: containerView)
            
            selectedItemsTable.deleteRows(at: [indexPath], with: .top)
            
            UIView.animate(withDuration: 1, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                newCellAdded.contentView.isHidden = false
                UIView.animate(withDuration: 1,
                               animations: {
                                superman.frame = superman.frame.offsetBy(dx: -(movingCell.frame.width + superman.frame.width),
                                                                         dy: 0)
                },
                               completion: { _ in
                                movingCell.removeFromSuperview()
                })
                viewToHide.isHidden = true
            })
        }
    }
}
