//
//  MultiSelectionTableControl.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 29/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class MultiSelectionTableControl : UIView,
                                                 UITableViewDataSource,
                                                 UITableViewDelegate {

    weak var dataSource: DataSource!
//    weak var dataSource: MultiSelectionDataSource<T>!
    
    fileprivate let allItemsTableContainer = UIView()
    fileprivate lazy var allItemsTable: UITableView = {
        let tableView = UITableView()

        tableView.tableFooterView = UIView()

        tableView.backgroundView = nil
        tableView.backgroundColor = self.allItemsTableBackgroundColor
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .interactive
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        return tableView
    }()
    
    fileprivate let selectedItemsTableContainer = UIView()
    fileprivate lazy var selectedItemsTable: UITableView = {
        let tableView = UITableView()
        
        tableView.tableFooterView = UIView()
        
        tableView.backgroundView = nil
        tableView.backgroundColor = self.selectedItemsTableBackgroundColor
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .interactive
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        return tableView
    }()
    
    fileprivate let seperator = UIView()
    
    fileprivate var seperatorCenterXConstraint: NSLayoutConstraint!
    fileprivate var allItemsTableLeadingConstraint: NSLayoutConstraint!
    fileprivate var selectedItemsTableTrailingConstraint: NSLayoutConstraint!
    
    fileprivate var isSelectingMode = false
    var seperatorWidthOffset: CGFloat = 100
    
    var controlBackgroundColor: UIColor = .black {
        didSet {
            blackLine.backgroundColor = controlBackgroundColor
        }
    }
    
    var allItemsTableBackgroundColor: UIColor = .defaultTableBackground {
        didSet {
            allItemsTable.backgroundColor = allItemsTableBackgroundColor
        }
    }
    
    var selectedItemsTableBackgroundColor: UIColor = .defaultTableBackground {
        didSet {
            selectedItemsTable.backgroundColor = selectedItemsTableBackgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = controlBackgroundColor
        
        buildSeperator()
        buildAllItemsTable()
        buildSelectedItemsTable()
        
        displayAllItems()
    }
    
    fileprivate let blackLine = UIView()
    private func buildSeperator() {
        addSubview(blackLine)
        blackLine.backgroundColor = controlBackgroundColor
        
        blackLine.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blackLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperatorCenterXConstraint = blackLine.centerXAnchor.constraint(equalTo: centerXAnchor)
        seperatorCenterXConstraint.isActive = true
        
        blackLine.widthAnchor.constraint(equalToConstant: 4).isActive = true
        blackLine.translatesAutoresizingMaskIntoConstraints = false
        
        let grayIndicator = UIView()
        blackLine.addSubview(grayIndicator)
        grayIndicator.layer.cornerRadius = 2
        grayIndicator.backgroundColor = .lightGray
        
        grayIndicator.centerXAnchor.constraint(equalTo: blackLine.centerXAnchor).isActive = true
        grayIndicator.centerYAnchor.constraint(equalTo: blackLine.centerYAnchor).isActive = true
        grayIndicator.widthAnchor.constraint(equalToConstant: 4).isActive = true
        grayIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        grayIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(seperator)
        seperator.backgroundColor = .clear
        
        seperator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        seperator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperator.leadingAnchor.constraint(equalTo: blackLine.leadingAnchor, constant: -10).isActive = true
        seperator.trailingAnchor.constraint(equalTo: blackLine.trailingAnchor, constant: 10).isActive = true
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipped(gesture:)))
        seperator.addGestureRecognizer(panGesture)
    }
    
    private func buildAllItemsTable() {
        addSubview(allItemsTableContainer)
        allItemsTableContainer.backgroundColor = .black
        
        allItemsTableLeadingConstraint = allItemsTableContainer.leadingAnchor.constraint(equalTo: leadingAnchor)
        allItemsTableLeadingConstraint.isActive = true
        allItemsTableContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        allItemsTableContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        allItemsTableContainer.trailingAnchor.constraint(equalTo: seperator.leadingAnchor, constant: 5).isActive = true
        allItemsTableContainer.translatesAutoresizingMaskIntoConstraints = false
        
        allItemsTableContainer.addSubview(allItemsTable)
        
        allItemsTable._alignToEdges(of: allItemsTableContainer)
        allItemsTable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func buildSelectedItemsTable() {
        addSubview(selectedItemsTableContainer)
        
        selectedItemsTableContainer.leadingAnchor.constraint(equalTo: seperator.trailingAnchor, constant: -5).isActive = true
        selectedItemsTableContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        selectedItemsTableContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        selectedItemsTableTrailingConstraint = selectedItemsTableContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
        selectedItemsTableTrailingConstraint.isActive = true
        selectedItemsTableContainer.translatesAutoresizingMaskIntoConstraints = false
        
        selectedItemsTableContainer.addSubview(selectedItemsTable)
        
        
        selectedItemsTable._alignToEdges(of: selectedItemsTableContainer)
        selectedItemsTable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func swipped(gesture: UIPanGestureRecognizer) {
        if gesture.translation(in: seperator).x > 0 {
            displayAllItems()
        } else {
            displaySelectedItems()
        }
    }
    
    func displayAllItems() {
        if !isSelectingMode {
            seperatorCenterXConstraint.constant = seperatorWidthOffset
            
            allItemsTableLeadingConstraint.constant = 0
            selectedItemsTableTrailingConstraint.constant += seperatorCenterXConstraint.constant * 2
            
            animateStateTransition()
            isSelectingMode = true
        }
    }
    
    fileprivate func displaySelectedItems() {
        if isSelectingMode {
            seperatorCenterXConstraint.constant = -seperatorWidthOffset
            
            allItemsTableLeadingConstraint.constant += seperatorCenterXConstraint.constant * 2
            selectedItemsTableTrailingConstraint.constant = 5
            
            animateStateTransition()
            isSelectingMode = false
        }
    }
    
    private func animateStateTransition() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                          self?.layoutIfNeeded()
                       },
                       completion: nil)
    }
    
    fileprivate var cellReuseId = "Cell"
    func register(_ nib: UINib, for cellReuseIdentifier: String) {
        cellReuseId = cellReuseIdentifier
        allItemsTable.register(nib, forCellReuseIdentifier: cellReuseId)
        selectedItemsTable.register(nib, forCellReuseIdentifier: cellReuseId)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        
        if tableView == allItemsTable {
           return dataSource.allItemsCount
        } else {
            return dataSource.selectedItemsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == allItemsTable {
            return dataSource.cell(for: indexPath, inAllItemsTable: tableView)
        } else {
            return dataSource.cell(for: indexPath, inSelectedItemsTable: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == selectedItemsTable ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == selectedItemsTable {
            let view = UIView()
            let label = UILabel()
            view.addSubview(label)
            label.text = "SELECTED"
            label.textColor = .gray
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        
        return nil
    }
    
    func reloadAllItemsTable() {
        allItemsTable.reloadData()
    }
    
    func putBackInAllItemsTable(at index: Int, selectedItemAt selectedItemIndex: Int) {
        let newIndexPath = IndexPath(item: index, section: 0)
        allItemsTable.insertRows(at: [newIndexPath], with: .bottom)
        
        var _newCellAdded: UITableViewCell?
        
        if let cell = allItemsTable.cellForRow(at: newIndexPath) {
            _newCellAdded = cell
        } else if let cell = allItemsTable.visibleCells.last {
            _newCellAdded = cell
        }
        
        guard let newCellAdded = _newCellAdded else { return }
        
        newCellAdded.contentView.isHidden = true
        let newCellConvertedFrame = newCellAdded.convert(newCellAdded.contentView.frame, to: self)
        
        let indexPath = IndexPath(item: selectedItemIndex, section: 0)
        guard let cellToDelete = selectedItemsTable.cellForRow(at: indexPath) else { return }
        
        if let movingCell = cellToDelete.contentView.snapshotView(afterScreenUpdates: false) {
            cellToDelete.contentView.isHidden = true
            addSubview(movingCell)
            movingCell.frame = selectedItemsTable.convert(cellToDelete.frame, to: self)
            
            self.selectedItemsTable.deleteRows(at: [indexPath], with: .top)
            
            UIView.animate(withDuration: 0.4, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                movingCell.removeFromSuperview()
                newCellAdded.contentView.isHidden = false
            })
        }
    }
    
    func removeFromSelected(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        selectedItemsTable.deleteRows(at: [indexPath], with: .right)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectedItemsTable {
            highlightCell(at: indexPath, in: tableView) { [weak self] in
                self?.dataSource.unselectedItem(at: indexPath.row)
            }
        } else {
            highlightCell(at: indexPath, in: tableView) { [weak self] in
                self?.dataSource.selectedItem(at: indexPath.row)
            }
        }
    }
    
    private let pathLayer = CAShapeLayer()
    let pathAnimation = CABasicAnimation(keyPath: "path")
    private func highlightCell(at indexPath: IndexPath,
                               in tableView: UITableView,
                               finish: @escaping () -> () = {}) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let center = cell.contentView.center
        
        let smallCircle = UIBezierPath(ovalIn: CGRect(x: center.x - 1,
                                                      y: center.y - 1,
                                                      width: 2,
                                                      height: 2))
        let bigCircle = UIBezierPath(arcCenter: cell.contentView.center,
                                     radius: cell.contentView.frame.width,
                                     startAngle: CGFloat(0),
                                     endAngle: CGFloat(2 * CGFloat.pi),
                                     clockwise: true)
        
        pathLayer.lineWidth = 0
        pathLayer.fillColor = UIColor.cellPulseColor.cgColor
        cell.contentView.layer.addSublayer(pathLayer)
        
        CATransaction.begin()
        
        
        pathAnimation.fromValue = smallCircle.cgPath
        pathAnimation.toValue = bigCircle.cgPath
        pathAnimation.duration = 0.2
        
        CATransaction.setCompletionBlock {
            finish()
        }
        
        pathLayer.add(pathAnimation, forKey: "animation")
        
        CATransaction.commit()
    }

    
    func addToSelectedItemsTable(at index: Int) {
     
        let count = selectedItemsTable.numberOfRows(inSection: 0)
        
        let newIndexPath = IndexPath(item: count, section: 0)
        selectedItemsTable.insertRows(at: [newIndexPath], with: .bottom)
        
        var _newCellAdded: UITableViewCell?
        
        if let cell = selectedItemsTable.cellForRow(at: newIndexPath) {
            _newCellAdded = cell
        } else if let cell = selectedItemsTable.visibleCells.last {
            _newCellAdded = cell
        }
        
        guard let newCellAdded = _newCellAdded else { return }
        
        newCellAdded.contentView.isHidden = true
        let newCellConvertedFrame = newCellAdded.convert(newCellAdded.contentView.frame, to: self)
        
        let indexPath = IndexPath(item: index, section: 0)
        guard let cellToDelete = allItemsTable.cellForRow(at: indexPath) else { return }
        
        if let movingCell = cellToDelete.contentView.snapshotView(afterScreenUpdates: false) {
            cellToDelete.contentView.isHidden = true
            addSubview(movingCell)
            movingCell.frame = allItemsTable.convert(cellToDelete.frame, to: self)
            
            allItemsTable.deleteRows(at: [indexPath], with: .top)
            
            UIView.animate(withDuration: 0.4, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                movingCell.removeFromSuperview()
                newCellAdded.contentView.isHidden = false
                cellToDelete.contentView.isHidden = false
            })
        }
    }
}

fileprivate extension UIColor {
    
    static var defaultTableBackground: UIColor {
        return UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    }
    
    static var cellPulseColor: UIColor {
        return UIColor(colorLiteralRed: 121/255, green: 2/255, blue: 188/255, alpha: 0.3)
    }
    
}

fileprivate extension UIView {
    func _alignToEdges(of view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
