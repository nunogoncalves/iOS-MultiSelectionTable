//
//  CellSelectionAnimator.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 07/12/16.
//
//

public protocol CellSelectionAnimator {
    func animate(_ cell: UITableViewCell,
                 startingAt origin: CGPoint?,
                 finish: (() -> ())?)
}
