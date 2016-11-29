//
//  ViewController.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 28/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

fileprivate struct AlbumIndex {
    
    let album: Album
    let index: Int
    
}

class ViewController: UIViewController {

    @IBOutlet weak var verticalLine: UIView!
    
    @IBOutlet weak var leftTable: UITableView!
    @IBOutlet weak var rightTable: UITableView!
    
    @IBOutlet weak var lineHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTableLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTableTrailingConstraint: NSLayoutConstraint!
    
    fileprivate var allAlbumIndexes: [AlbumIndex] = [Album(band: Band(name: "Nirvana"), name: "Nevermind", cover: #imageLiteral(resourceName: "nevermind")),
                     Album(band: Band(name: "Red Hot Chili Peppers"), name: "Californication", cover: #imageLiteral(resourceName: "californication")),
                     Album(band: Band(name: "BloodHound Gang"), name: "The Balled of Chasey Lane", cover: #imageLiteral(resourceName: "badadchaseylane")),
                     Album(band: Band(name: "Limp Bizkit"), name: "Three Dollar Bill Yall", cover: #imageLiteral(resourceName: "threedollarbillyall")),
                     Album(band: Band(name: "Metallica"), name: "S&M", cover: #imageLiteral(resourceName: "s&m")),
                     Album(band: Band(name: "Roxette"), name: "Joyride", cover: #imageLiteral(resourceName: "joyride")),
                     Album(band: Band(name: "U2"), name: "Best of", cover: #imageLiteral(resourceName: "u2bestof")),
                     Album(band: Band(name: "Queen"), name: "Greatest Hits 2", cover: #imageLiteral(resourceName: "queengreatest2")),
                     Album(band: Band(name: "Pink"), name: "I'm not dead", cover: #imageLiteral(resourceName: "imnotdead")),
                     Album(band: Band(name: "Guns N Roses"), name: "Appetite for Destruction", cover: #imageLiteral(resourceName: "appetite-for-destruction")),
                     Album(band: Band(name: "AC/DC"), name: "Black Ice", cover: #imageLiteral(resourceName: "blackice")),
                     Album(band: Band(name: "Pink Floyd"), name: "Dark Side of the Moon", cover: #imageLiteral(resourceName: "Dark_Side_of_the_Moon")),
                     Album(band: Band(name: "Eurytmics"), name: "Touch", cover: #imageLiteral(resourceName: "Eurythmics_-_Touch")),
                     Album(band: Band(name: "Coldplay"), name: "Ghosts of Stories", cover: #imageLiteral(resourceName: "ghoststoriesfull")),
                     Album(band: Band(name: "Pink"), name: "Funhouse", cover: #imageLiteral(resourceName: "funhouse")),
                     Album(band: Band(name: "Bon Jovi"), name: "It's My Life", cover: #imageLiteral(resourceName: "itsmylife")),
                     Album(band: Band(name: "Ramstein"), name: "Rosenrot", cover: #imageLiteral(resourceName: "rosenrot")),
                     Album(band: Band(name: "Michael Jackson"), name: "Thriller", cover: #imageLiteral(resourceName: "thriller")),
                     Album(band: Band(name: "INXS"), name: "Switch", cover: #imageLiteral(resourceName: "switch")),
                     ].enumerated().map { AlbumIndex(album: $1, index: $0) }
    
    
    fileprivate var selectedAlbumIndexes: [AlbumIndex] = []
    
    var isSelectingMode = true
    
    var seperatorWidthOffset: CGFloat = 130
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        leftTable.estimatedRowHeight = 100
        leftTable.rowHeight = UITableViewAutomaticDimension
        
        rightTable.estimatedRowHeight = 100
        rightTable.rowHeight = UITableViewAutomaticDimension
        
        rightTable.dataSource = self
        leftTable.dataSource = self
        rightTable.delegate = self
        leftTable.delegate = self
        
        
        self.lineHorizontalConstraint.constant = seperatorWidthOffset
        
        self.rightTableTrailingConstraint.constant = -seperatorWidthOffset * 2

        view.layoutIfNeeded()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipped(gesture:)))
        verticalLine.addGestureRecognizer(panGesture)
    }
    
    @objc private func swipped(gesture: UIPanGestureRecognizer) {
        if gesture.translation(in: verticalLine).x > 0 {
            displayAllItems()
        } else {
            displaySelectedItems()
        }
    }
    
    fileprivate func displayAllItems() {
        //left visible
        if !isSelectingMode {
            self.lineHorizontalConstraint.constant = seperatorWidthOffset
            
            self.leftTableLeadingConstraint.constant = 5
            self.rightTableTrailingConstraint.constant -= self.lineHorizontalConstraint.constant * 2
            
            animateDisplayChange()
        }
        isSelectingMode = true
    }
    
    fileprivate func displaySelectedItems() {
        //right visible
        if isSelectingMode {
            self.lineHorizontalConstraint.constant = -seperatorWidthOffset
            
            self.leftTableLeadingConstraint.constant += self.lineHorizontalConstraint.constant * 2
            self.rightTableTrailingConstraint.constant = 5
            
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
                        self.view.layoutIfNeeded()
                       },
                       completion: nil)
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTable {
            return allAlbumIndexes.count
        } else {
            return selectedAlbumIndexes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AlbumCell
        if tableView == leftTable {
            cell.nameLabel.text = allAlbumIndexes[indexPath.row].album.band.name
            cell.subtitleLabel.text = allAlbumIndexes[indexPath.row].album.name
            cell.albumImageView.image = allAlbumIndexes[indexPath.row].album.cover
            
        } else {
            cell.nameLabel.text = selectedAlbumIndexes[indexPath.row].album.band.name
            cell.subtitleLabel.text = selectedAlbumIndexes[indexPath.row].album.name
            cell.albumImageView.image = selectedAlbumIndexes[indexPath.row].album.cover
            
        }
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == rightTable {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == rightTable {
            let view = UIView()
            let label = UILabel()
            view.addSubview(label)
            label.text = "SELECTED"
            label.textColor = .gray
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == rightTable {
            highlightCell(at: indexPath, in: tableView) {
                self.unselectAlbum(at: indexPath)
            }
        } else {
            highlightCell(at: indexPath, in: tableView) {
                self.selectAlbum(at: indexPath)
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
        pathLayer.fillColor = UIColor(hex: 0x7902BC, alpha: 0.3).cgColor
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
    
    private func selectAlbum(at indexPath: IndexPath) {
        let album = allAlbumIndexes.remove(at: indexPath.row)
        selectedAlbumIndexes.append(album)
        
        let count = rightTable.numberOfRows(inSection: 0)
        
        let newIndexPath = IndexPath(item: count, section: 0)
        rightTable.insertRows(at: [newIndexPath], with: .bottom)
        
        var _newCellAdded: UITableViewCell?
        
        if let cell = rightTable.cellForRow(at: newIndexPath) {
            _newCellAdded = cell
        } else if let cell = rightTable.visibleCells.last {
            _newCellAdded = cell
        }
        
        guard let newCellAdded = _newCellAdded else { return }
        
        newCellAdded.contentView.isHidden = true
        let newCellConvertedFrame = newCellAdded.convert(newCellAdded.contentView.frame, to: self.view)
        
        guard let cellToDelete = leftTable.cellForRow(at: indexPath) else { return }
        
        if let movingCell = cellToDelete.contentView.snapshotView(afterScreenUpdates: false) {
            cellToDelete.contentView.isHidden = true
            view.addSubview(movingCell)
            movingCell.frame = leftTable.convert(cellToDelete.frame, to: self.view)
            
            self.leftTable.deleteRows(at: [indexPath], with: .top)
            
            UIView.animate(withDuration: 0.4, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                movingCell.removeFromSuperview()
                newCellAdded.contentView.isHidden = false
                cellToDelete.contentView.isHidden = false
            })
        }
    }

    private func unselectAlbum(at indexPath: IndexPath) {
        let album = selectedAlbumIndexes.remove(at: indexPath.row)
        
        let indexToAdd = findIndexToAdd(album, in: allAlbumIndexes)
        allAlbumIndexes.insert(album, at: indexToAdd)
        
        let newIndexPath = IndexPath(item: indexToAdd, section: 0)
        leftTable.insertRows(at: [newIndexPath], with: .bottom)
        
        var _newCellAdded: UITableViewCell?
        
        if let cell = leftTable.cellForRow(at: newIndexPath) {
            _newCellAdded = cell
        } else if let cell = leftTable.visibleCells.last {
            _newCellAdded = cell
        }
        
        guard let newCellAdded = _newCellAdded else { return }
        
        newCellAdded.contentView.isHidden = true
        let newCellConvertedFrame = newCellAdded.convert(newCellAdded.contentView.frame, to: self.view)
        
        guard let cellToDelete = rightTable.cellForRow(at: indexPath) else { return }
        
        if let movingCell = cellToDelete.contentView.snapshotView(afterScreenUpdates: false) {
            cellToDelete.contentView.isHidden = true
            view.addSubview(movingCell)
            movingCell.frame = rightTable.convert(cellToDelete.frame, to: self.view)
            
            self.rightTable.deleteRows(at: [indexPath], with: .top)
            
            UIView.animate(withDuration: 0.4, animations: {
                movingCell.frame = newCellConvertedFrame
            }, completion: { _ in
                movingCell.removeFromSuperview()
                newCellAdded.contentView.isHidden = false
                
                if self.selectedAlbumIndexes.isEmpty {
                    self.displayAllItems()
                }

            })
        }
        
    }

    private func findIndexToAdd(_ album: AlbumIndex, in list: [AlbumIndex]) -> Int {
        var indexToReturn = 0
        for (index, iteratedAlbumIndex) in list.enumerated() {
            if iteratedAlbumIndex.index >= album.index {
                indexToReturn = index
                break
            }
        }
        return indexToReturn
    }
    
}

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue:  CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

