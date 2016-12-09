//
//  HeroesViewController.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 08/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit
import MultiSelectionTableView

class HeroesViewController : UIViewController {
    
    @IBOutlet weak var multiSelectionTableContainer: UIStackView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var multiSelectionDataSource: MultiSelectionDataSource<Album>!
    @IBOutlet fileprivate weak var multiSelectionTableView: MultiSelectionTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multiSelectionDataSource = MultiSelectionDataSource(multiSelectionTableView: multiSelectionTableView)
        multiSelectionDataSource.delegate = self
        multiSelectionDataSource.register(nib: UINib(nibName: "AlbumCell", bundle: nil), for: "AlbumCell")
        
        multiSelectionDataSource.allItems = Album.all
        
        multiSelectionTableView.dataSource = multiSelectionDataSource
        multiSelectionTableView.cellAnimator = CellPulseAnimator(pulseColor: .black)
    }
    
}

extension HeroesViewController : MultiSelectionTableDelegate {
    
    func paint(_ cell: UITableViewCell, for indexPath: IndexPath, with item: Any) {
        if let cell = cell as? AlbumCell,
            let album = item as? Album {
            cell.nameLabel.text = album.band.name
            cell.subtitleLabel.text = album.name
            cell.albumImageView.image = album.cover
            cell.yearLabel.text = "\(album.year)"
        }
    }
    
}
