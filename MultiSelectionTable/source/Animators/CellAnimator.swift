//
//  CellAnimator.swift
//  Pods
//
//  Created by Nuno Gonçalves on 07/12/16.
//
//

public protocol CellAnimator {
    func animate(_ cell: UITableViewCell,
                 startingAt origin: CGPoint?,
                 finish: (() -> ())?)
}
