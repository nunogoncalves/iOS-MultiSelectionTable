//
//  HeroesViewController.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 08/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit
import MultiSelectionTableView
import SDWebImage

class HeroesViewController : UIViewController {
    
    @IBOutlet weak var multiSelectionTableContainer: UIStackView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var multiSelectionDataSource: MultiSelectionDataSource<Hero>!
    @IBOutlet fileprivate weak var multiSelectionTableView: MultiSelectionTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multiSelectionDataSource = MultiSelectionDataSource(multiSelectionTableView: multiSelectionTableView)
        multiSelectionDataSource.delegate = self
        multiSelectionDataSource.register(nib: UINib(nibName: "HeroCell", bundle: nil), for: "HeroCell")
        
        Hero.all { [weak self] heroes in
            self?.multiSelectionDataSource.allItems = heroes
        }
        
        multiSelectionTableView.dataSource = multiSelectionDataSource
        multiSelectionTableView.cellAnimator = CellSelectionPulseAnimator(pulseColor: .black)
        multiSelectionTableView.cellTransitioner = CellFlyerAnimator()
    }
    
}

extension HeroesViewController : MultiSelectionTableDelegate {
    
    func paint(_ cell: UITableViewCell, for indexPath: IndexPath, with item: Any) {
        if let cell = cell as? HeroCell,
            let hero = item as? Hero {
            cell.heroNameLabel.text = hero.name
            cell.heroImageView.sd_setImage(with: hero.imageURL)
        }
    }
    
}
