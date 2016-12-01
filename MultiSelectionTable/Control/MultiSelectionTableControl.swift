//
//  MultiSelectionTableControl.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 29/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

enum State {
    case displaying //idea here is to hide the selection table
    case selecting //idea is to show the selectio table
}

@IBDesignable
//class MultiSelectionTableControl<T> : UIControl {
class MultiSelectionTableControl<T: Equatable> : UIView,
                                                 UITableViewDataSource,
                                                 UITableViewDelegate {

    fileprivate let allItemsTableContainer = UIView()
    fileprivate let allItemsTable = UITableView()
    
    fileprivate let selectedItemsTableContainer = UIView()
    fileprivate let selectedItemsTable = UITableView()
    
    fileprivate let seperator = UIView()
    
    fileprivate var seperatorCenterXConstraint: NSLayoutConstraint!
    fileprivate var allItemsTableLeadingConstraint: NSLayoutConstraint!
    fileprivate var selectedItemsTableTrailingConstraint: NSLayoutConstraint!
    
    fileprivate var isSelectingMode = false
    fileprivate var seperatorWidthOffset: CGFloat = 100
    
    weak var delegate: MultiSelectionTableDelegate?
    
    fileprivate var allItemsIndexes: [ItemIndex<T>] = []
    var allItems: [T] = [] {
        didSet {
            let _selectedItems = selectedItemsIndexes.map{ $0.item }
            allItemsIndexes = allItems.enumerated().flatMap { index, item in
                if let indexOfItem = _selectedItems.index(of: item) {
                    selectedItemsIndexes[indexOfItem].index = index
                    return nil
                }
                return ItemIndex(item: item, index: index)
            }
            allItemsTable.reloadData()
        }
    }
    
    fileprivate var selectedItemsIndexes: [ItemIndex<T>] = []
    private (set) var selectedItems: [T] = [] {
        didSet {
            selectedItemsIndexes = selectedItems.enumerated().map { ItemIndex(item: $1, index: $0) }
        }
    }
    
    @IBInspectable var controlBackgroundColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var allItemsTableBackgroundColor: UIColor = .defaultTableBackground {
        didSet {
            allItemsTable.setNeedsDisplay()
            allItemsTable.backgroundColor = allItemsTableBackgroundColor
        }
    }
    
    @IBInspectable var selectedItemsTableBackgroundColor: UIColor = .defaultTableBackground {
        didSet {
            selectedItemsTable.setNeedsDisplay()
            selectedItemsTable.backgroundColor = selectedItemsTableBackgroundColor
        }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        backgroundColor = controlBackgroundColor
//        blackLine.backgroundColor = controlBackgroundColor
//        selectedItemsTable.backgroundColor = selectedItemsTableBackgroundColor
//        allItemsTable.backgroundColor = allItemsTableBackgroundColor
//        
//        allItemsTable.separatorColor = .clear
//        selectedItemsTable.separatorColor = .clear
//        
//        selectedItemsTableContainer.backgroundColor = UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)
//        allItemsTableContainer.backgroundColor = UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)
//    }
//    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        buildSeperator()
        buildAllItemsTable()
        buildSelectedItemsTable()
        
        allItemsTable.delegate = self
        allItemsTable.dataSource = self
        selectedItemsTable.delegate = self
        selectedItemsTable.dataSource = self
        
        allItemsTable.estimatedRowHeight = 100
        allItemsTable.rowHeight = UITableViewAutomaticDimension
        
        selectedItemsTable.estimatedRowHeight = 100
        selectedItemsTable.rowHeight = UITableViewAutomaticDimension
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipped(gesture:)))
        seperator.addGestureRecognizer(panGesture)
        
        displayAllItems()
        backgroundColor = controlBackgroundColor
                selectedItemsTableContainer.backgroundColor = UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)
                allItemsTableContainer.backgroundColor = UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)

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
        
    }
    
    private func buildAllItemsTable() {
        addSubview(allItemsTableContainer)
        allItemsTableContainer.backgroundColor = .black//allItemsTableBackgroundColor
        
        allItemsTableLeadingConstraint = allItemsTableContainer.leadingAnchor.constraint(equalTo: leadingAnchor)
        allItemsTableLeadingConstraint.isActive = true
        allItemsTableContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        allItemsTableContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        allItemsTableContainer.trailingAnchor.constraint(equalTo: seperator.leadingAnchor, constant: 5).isActive = true
        allItemsTableContainer.translatesAutoresizingMaskIntoConstraints = false
        
        allItemsTable.keyboardDismissMode = .interactive
        
        let footer = UIView()
        allItemsTable.tableFooterView = footer
        
        allItemsTableContainer.addSubview(allItemsTable)
        
        allItemsTable.backgroundView = nil
        allItemsTable.backgroundColor = allItemsTableBackgroundColor
        allItemsTable.separatorColor = .clear
        
        allItemsTable.topAnchor.constraint(equalTo: allItemsTableContainer.topAnchor).isActive = true
        allItemsTable.leadingAnchor.constraint(equalTo: allItemsTableContainer.leadingAnchor).isActive = true
        allItemsTable.bottomAnchor.constraint(equalTo: allItemsTableContainer.bottomAnchor).isActive = true
        allItemsTable.trailingAnchor.constraint(equalTo: allItemsTableContainer.trailingAnchor).isActive = true
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
        
        let footer = UIView()
        selectedItemsTable.tableFooterView = footer
        
        selectedItemsTableContainer.addSubview(selectedItemsTable)
        
        selectedItemsTable.backgroundView = nil
        selectedItemsTable.backgroundColor = selectedItemsTableBackgroundColor
        
        selectedItemsTable.keyboardDismissMode = .interactive
        
        selectedItemsTable.topAnchor.constraint(equalTo: selectedItemsTableContainer.topAnchor).isActive = true
        selectedItemsTable.leadingAnchor.constraint(equalTo: selectedItemsTableContainer.leadingAnchor).isActive = true
        selectedItemsTable.bottomAnchor.constraint(equalTo: selectedItemsTableContainer.bottomAnchor).isActive = true
        selectedItemsTable.trailingAnchor.constraint(equalTo: selectedItemsTableContainer.trailingAnchor).isActive = true
        selectedItemsTable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func swipped(gesture: UIPanGestureRecognizer) {
        if gesture.translation(in: seperator).x > 0 {
            displayAllItems()
        } else {
            displaySelectedItems()
        }
    }
    
    fileprivate func displayAllItems() {
        //show all items
        if !isSelectingMode {
            seperatorCenterXConstraint.constant = seperatorWidthOffset
            
            allItemsTableLeadingConstraint.constant = 0
            selectedItemsTableTrailingConstraint.constant += seperatorCenterXConstraint.constant * 2
            
            animateDisplayChange()
        }
        isSelectingMode = true
    }
    
    fileprivate func displaySelectedItems() {
        //show selected items
        if isSelectingMode {
            seperatorCenterXConstraint.constant = -seperatorWidthOffset
            
            allItemsTableLeadingConstraint.constant += seperatorCenterXConstraint.constant * 2
            selectedItemsTableTrailingConstraint.constant = 5
            
            animateDisplayChange()
        }
        isSelectingMode = false
    }
    
    private func animateDisplayChange() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                        self.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    fileprivate var cellReuseId = "Cell"
    func register(nib: UINib, for cellReuseIdentifier: String) {
        cellReuseId = cellReuseIdentifier
        allItemsTable.register(nib, forCellReuseIdentifier: cellReuseId)
        selectedItemsTable.register(nib, forCellReuseIdentifier: cellReuseId)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == allItemsTable {
            return allItemsIndexes.count
        } else {
            return selectedItemsIndexes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        let item: ItemIndex<T>
        if tableView == allItemsTable {
            item = allItemsIndexes[indexPath.row]
        } else {
            item = selectedItemsIndexes[indexPath.row]
        }
        
        delegate?.paint(cell, for: indexPath, with: item.item)
        
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectedItemsTable {
            highlightCell(at: indexPath, in: tableView) {
                self.unselectItem(at: indexPath)
            }
        } else {
            highlightCell(at: indexPath, in: tableView) {
                self.selectItem(at: indexPath)
            }
        }
    }
    
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
        
        
        let pathLayer = CAShapeLayer()
        pathLayer.lineWidth = 0
        pathLayer.fillColor = UIColor(colorLiteralRed: 121/255, green: 2/255, blue: 188/255, alpha: 0.3).cgColor
        pathLayer.path = smallCircle.cgPath
        cell.contentView.layer.addSublayer(pathLayer)
        
        CATransaction.begin()
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = smallCircle.cgPath
        pathAnimation.toValue = bigCircle.cgPath
        pathAnimation.duration = 0.2
        
        CATransaction.setCompletionBlock {
            finish()
        }
        
        pathLayer.add(pathAnimation, forKey: "animation")
        
        CATransaction.commit()
    }
    
    private func selectItem(at indexPath: IndexPath) {
        
        let item = allItemsIndexes.remove(at: indexPath.row)
        selectedItemsIndexes.append(item)
        
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
    
    private func unselectItem(at indexPath: IndexPath) {
        let item = selectedItemsIndexes.remove(at: indexPath.row)
        
        guard let indexToAdd = findIndexToAdd(item, in: allItemsIndexes) else {
            self.selectedItemsTable.deleteRows(at: [indexPath], with: .top)
            return
        }
        
        allItemsIndexes.insert(item, at: indexToAdd)
        
        let newIndexPath = IndexPath(item: indexToAdd, section: 0)
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
                
                if self.selectedItemsIndexes.isEmpty {
                    self.displayAllItems()
                }
                
            })
        }
        
    }
    
    private func findIndexToAdd(_ item: ItemIndex<T>, in list: [ItemIndex<T>]) -> Int? {
        guard allItems.contains(item.item) else { return nil }
        
        var indexToReturn = 0
        for (index, iteratedItemIndex) in list.enumerated() {
            if iteratedItemIndex.index >= item.index {
                indexToReturn = index
                break
            }
        }
        return indexToReturn
    }
    
}

fileprivate extension UIColor {
    
    static var defaultTableBackground: UIColor {
        return UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    }
    
}
