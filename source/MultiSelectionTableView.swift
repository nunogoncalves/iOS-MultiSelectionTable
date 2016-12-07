//
//  MultiSelectionTableControl.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 29/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

//
//  MultiSelectionTableControl.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 29/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

@IBDesignable
public class MultiSelectionTableView : UIView {
    
    public weak var dataSource: DataSource!
    
    fileprivate let allItemsTable = UITableView()
    fileprivate let seperator = UIView()
    fileprivate let selectedItemsTable = UITableView()
    
    fileprivate var seperatorCenterXConstraint: NSLayoutConstraint!
    fileprivate var allItemsTableLeadingConstraint: NSLayoutConstraint!
    fileprivate var selectedItemsTableTrailingConstraint: NSLayoutConstraint!
    
    fileprivate var isSelectingMode = false
    @IBInspectable var seperatorWidthOffset: CGFloat = 100
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        allItemsTable.backgroundColor = allItemsTableBackgroundColor
        allItemsTable.separatorColor = .clear
        allItemsTable.headerView(forSection: 0)?.backgroundColor = allItemsTableBackgroundColor
        
        blackLine.backgroundColor = seperatorColor
        
        selectedItemsTable.backgroundColor = selectedItemsTableBackgroundColor
        selectedItemsTable.separatorColor = .clear
        selectedItemsTable.headerView(forSection: 0)?.backgroundColor = selectedItemsTableBackgroundColor
    }
    
    @IBInspectable
    public var controlBackgroundColor: UIColor = .black {
        didSet {
            backgroundColor = controlBackgroundColor
        }
    }
    
    @IBInspectable
    public var seperatorColor: UIColor = .black {
        didSet {
            blackLine.backgroundColor = seperatorColor
        }
    }
    
    @IBInspectable
    public var allItemsTableBackgroundColor: UIColor = .defaultTableBackground {
        didSet {
            allItemsTable.backgroundColor = allItemsTableBackgroundColor
        }
    }
    
    @IBInspectable
    public var selectedItemsTableBackgroundColor: UIColor = .defaultTableBackground {
        didSet {
            selectedItemsTable.backgroundColor = selectedItemsTableBackgroundColor
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
        blackLine.backgroundColor = seperatorColor
        
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
        addSubview(allItemsTable)
        configure(allItemsTable)
        
        allItemsTableLeadingConstraint = allItemsTable.leadingAnchor.constraint(equalTo: leadingAnchor)
        allItemsTableLeadingConstraint.isActive = true
        allItemsTable.topAnchor.constraint(equalTo: topAnchor).isActive = true
        allItemsTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        allItemsTable.trailingAnchor.constraint(equalTo: seperator.leadingAnchor, constant: 5).isActive = true
        
        allItemsTable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func buildSelectedItemsTable() {
        addSubview(selectedItemsTable)
        configure(selectedItemsTable)
        
        selectedItemsTable.leadingAnchor.constraint(equalTo: seperator.trailingAnchor, constant: -5).isActive = true
        selectedItemsTable.topAnchor.constraint(equalTo: topAnchor).isActive = true
        selectedItemsTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        selectedItemsTableTrailingConstraint = selectedItemsTable.trailingAnchor.constraint(equalTo: trailingAnchor)
        selectedItemsTableTrailingConstraint.isActive = true
        selectedItemsTable.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configure(_ tableView: UITableView) {
        tableView.tableFooterView = UIView()
        
        tableView.backgroundView = nil
        tableView.backgroundColor = self.allItemsTableBackgroundColor
        tableView.separatorColor = .white
        tableView.keyboardDismissMode = .interactive
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTable(gestureRecognizer:)))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc private func didTapTable(gestureRecognizer: UITapGestureRecognizer) {
        guard let tableView = gestureRecognizer.view as? UITableView else { return }
        
        let location = gestureRecognizer.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath)
            else {
                return
        }
        
        let origin = tableView.convert(location, to: cell.contentView)
        
        if tableView == selectedItemsTable {
            highlightCell(at: indexPath, in: tableView, startingAt: origin) { [weak self] in
                self?.dataSource.unselectedItem(at: indexPath.row)
            }
        } else {
            highlightCell(at: indexPath, in: tableView, startingAt: origin) { [weak self] in
                self?.dataSource.selectedItem(at: indexPath.row)
            }
        }
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
    
    func register(cellClass: AnyClass?, for cellReuseIdentifier: String) {
        cellReuseId = cellReuseIdentifier
        allItemsTable.register(cellClass, forCellReuseIdentifier: cellReuseId)
        selectedItemsTable.register(cellClass, forCellReuseIdentifier: cellReuseId)
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
    
    
    private let pathLayer = CAShapeLayer()
    private let pathAnimation = CABasicAnimation(keyPath: "path")
    private let opacityAnimation = CABasicAnimation(keyPath: "opacity")
    
    fileprivate func highlightCell(at indexPath: IndexPath,
                                   in tableView: UITableView,
                                   startingAt origin: CGPoint? = nil,
                                   finish: @escaping () -> () = {}) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let startingPoint = origin ?? cell.contentView.center
        
        let smallCircle = UIBezierPath(ovalIn: CGRect(x: startingPoint.x - 1,
                                                      y: startingPoint.y - 1,
                                                      width: 2,
                                                      height: 2))
        
        let maxRadius = maxDistance(between: startingPoint, andCornersIn: cell.contentView.frame)
        
        let bigCircle = UIBezierPath(arcCenter: startingPoint,
                                     radius: maxRadius,
                                     startAngle: CGFloat(0),
                                     endAngle: CGFloat(2 * CGFloat.pi),
                                     clockwise: true)
        
        pathLayer.lineWidth = 0
        cell.contentView.layer.masksToBounds = true
        pathLayer.fillColor = UIColor.cellPulseColor.cgColor
        cell.contentView.layer.addSublayer(pathLayer)
        
        CATransaction.begin()
        
        
        pathAnimation.fromValue = smallCircle.cgPath
        pathAnimation.toValue = bigCircle.cgPath
        pathAnimation.duration = 0.3
        
        CATransaction.setCompletionBlock {
            finish()
        }
        
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.3
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.animations = [pathAnimation, opacityAnimation]
        
        pathLayer.add(animationGroup, forKey: "animation")
        
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

extension MultiSelectionTableView : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        
        if tableView == allItemsTable {
            return dataSource.allItemsCount
        } else {
            return dataSource.selectedItemsCount
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == allItemsTable {
            return dataSource.cell(for: indexPath, inAllItemsTable: tableView)
        } else {
            return dataSource.cell(for: indexPath, inSelectedItemsTable: tableView)
        }
    }

    
}

extension MultiSelectionTableView : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == selectedItemsTable ? 50 : 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
}

fileprivate extension UIColor {
    
    static var defaultTableBackground: UIColor {
        return UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    }
    
    static var cellPulseColor: UIColor {
        return UIColor(colorLiteralRed: 121/255, green: 2/255, blue: 188/255, alpha: 0.3)
    }
    
}

func maxDistance(between point: CGPoint, andCornersIn rect: CGRect) -> CGFloat {
    let px = point.x
    let py = point.y
    
    let corners = [
        CGPoint(x: rect.origin.x, y: rect.origin.y),
        CGPoint(x: rect.width, y: rect.origin.y),
        CGPoint(x: rect.origin.x, y: rect.height),
        CGPoint(x: rect.width, y: rect.height)
    ]
    
    var maxDistance: CGFloat = 0
    
    for corner in corners {
        let dx = abs(px - corner.x)
        let dy = abs(py - corner.y)
        let length = sqrt(dx * dx + dy * dy)
        maxDistance = max(length, maxDistance)
    }
    return maxDistance
}
