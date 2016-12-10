//
//  MultiSelectionTableControl.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 29/11/16.
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
    
    public var cellAnimator: CellSelectionAnimator = CellSelectionPulseAnimator(pulseColor: .defaultCellPulseColor)
    public var cellTransitioner: CellTransitionAnimator = CellMover()
    
    override public func awakeFromNib() {
        super.awakeFromNib()

        allItemsTable.backgroundColor = allItemsTableBackgroundColor
        allItemsTable.separatorColor = .clear
        
        blackLine.backgroundColor = seperatorColor
        
        selectedItemsTable.backgroundColor = selectedItemsTableBackgroundColor
        selectedItemsTable.separatorColor = .clear
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
    
    public var allItemsContentInset: UIEdgeInsets = .zero {
        didSet {
            allItemsTable.contentInset = allItemsContentInset
        }
    }
    
    public var selectedItemsContentInset: UIEdgeInsets = .zero {
        didSet {
            selectedItemsTable.contentInset = selectedItemsContentInset
        }
    }
    
    override init(frame: CGRect) {
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

        selectedItemsTable.tableHeaderView = TableViewHeader(title: "SELECTED")
        
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
        tableView.separatorColor = .clear
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
        
        let actionAnimation: () -> ()
        if tableView == selectedItemsTable {
            actionAnimation = { [weak self] in
                self?.dataSource.unselectedItem(at: indexPath.row)
            }
        } else {
            actionAnimation = { [weak self] in
                self?.dataSource.selectedItem(at: indexPath.row)
            }
        }
        
        cellAnimator.animate(cell, startingAt: origin) {
            actionAnimation()
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
    
    func register(anyClass: AnyClass?, for cellReuseIdentifier: String) {
        cellReuseId = cellReuseIdentifier
        allItemsTable.register(anyClass, forCellReuseIdentifier: cellReuseId)
        selectedItemsTable.register(anyClass, forCellReuseIdentifier: cellReuseId)
    }
    
    func reloadAllItemsTable() {
        allItemsTable.reloadData()
    }
    
    func putBackInAllItemsTable(at index: Int, selectedItemAt selectedItemIndex: Int) {
        
        let indexPathToRemove = IndexPath(item: selectedItemIndex, section: 0)
        let newIndexPath = IndexPath(item: index, section: 0)
        
        cellTransitioner.unselectionTransition(in: self,
                                               fromTableView: selectedItemsTable,
                                               fromIndexPath: indexPathToRemove,
                                               toTableView: allItemsTable, toIndexPath: newIndexPath)
    }
    
    func removeFromSelected(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        selectedItemsTable.deleteRows(at: [indexPath], with: .right)
    }
    
    func addToSelectedItemsTable(at index: Int) {
        let count = selectedItemsTable.numberOfRows(inSection: 0)
        let newIndexPath = IndexPath(item: count, section: 0)
        let indexPath = IndexPath(item: index, section: 0)
        cellTransitioner.selectionTransition(in: self,
                                             fromTableView: allItemsTable,
                                             fromIndexPath: indexPath,
                                             toTableView: selectedItemsTable,
                                             toIndexPath: newIndexPath)
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

extension MultiSelectionTableView : UITableViewDelegate { }

fileprivate extension UIColor {
    static var defaultTableBackground: UIColor {
        return UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    }
    
    static var defaultCellPulseColor: UIColor {
        return UIColor(colorLiteralRed: 121/255, green: 2/255, blue: 188/255, alpha: 0.3)
    }
}
