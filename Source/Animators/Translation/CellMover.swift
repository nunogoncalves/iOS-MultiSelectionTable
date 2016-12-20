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
        
        toTableView.insertRows(at: [toIndexPath], with: .fade)

        animateTransition(defaultRemovingAnimation: .right,
                          sourceTableView: fromTableView,
                          sourceIndexPath: fromIndexPath,
                          destinationTableView: toTableView,
                          destinationIndexPath: toIndexPath,
                          containerView: containerView)
    }

    public func unselectionTransition(in containerView: UIView,
                                      fromTableView: UITableView,
                                      fromIndexPath: IndexPath,
                                      toTableView: UITableView,
                                      toIndexPath: IndexPath) {
        
        toTableView.insertRows(at: [toIndexPath], with: .bottom)
        
        animateTransition(defaultRemovingAnimation: .left,
                          sourceTableView: fromTableView,
                          sourceIndexPath: fromIndexPath,
                          destinationTableView: toTableView,
                          destinationIndexPath: toIndexPath,
                          containerView: containerView)
    }

    private func animateTransition(defaultRemovingAnimation: UITableViewRowAnimation,
                                   sourceTableView: UITableView,
                                   sourceIndexPath: IndexPath,
                                   destinationTableView: UITableView,
                                   destinationIndexPath: IndexPath,
                                   containerView: UIView) {
        
        guard let oldCell = sourceTableView.cellForRow(at: sourceIndexPath),
            let newCell = destinationTableView.cellForRow(at: destinationIndexPath),
            let movingCell = oldCell.contentView.snapshotView(afterScreenUpdates: false)
        else {
            sourceTableView.deleteRows(at: [sourceIndexPath], with: defaultRemovingAnimation)
            return
        }
       
        newCell.contentView.isHidden = true
        oldCell.contentView.isHidden = true
        
        containerView.addSubview(movingCell)
        movingCell.frame = sourceTableView.convert(oldCell.frame, to: containerView)
        
        sourceTableView.deleteRows(at: [sourceIndexPath], with: .fade)
        
        let newCellConvertedFrame = newCell.convert(newCell.contentView.frame, to: containerView)
        
        UIView.animate(withDuration: 0.4, animations: {
            movingCell.frame = newCellConvertedFrame
        }, completion: { _ in
            movingCell.removeFromSuperview()
            newCell.contentView.isHidden = false
            oldCell.contentView.isHidden = false // because of reusage.
        })
    }
    
}
