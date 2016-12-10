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
    @IBOutlet weak var searchTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var multiSelectionDataSource: MultiSelectionDataSource<Hero>!
    @IBOutlet fileprivate weak var multiSelectionTableView: MultiSelectionTableView!

    @IBAction func clearSearchText() {
        searchTextField.text = nil
        searchTextField.resignFirstResponder()
        searchText = ""
    }
    
    fileprivate var searchText = "" {
        didSet {
            searchHeroes()
        }
    }
    
    fileprivate func searchHeroes() {
        Hero.all(named: searchText) { [weak self] heroes in
            self?.allHeroes = heroes
        }
    }
    
    fileprivate var allHeroes: [Hero] = [] {
        didSet {
            multiSelectionDataSource.allItems = allHeroes
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multiSelectionDataSource = MultiSelectionDataSource(multiSelectionTableView: multiSelectionTableView)
        multiSelectionDataSource.delegate = self
        multiSelectionDataSource.register(nib: UINib(nibName: "HeroCell", bundle: nil), for: "HeroCell")
        
        multiSelectionDataSource.allItems = allHeroes
        searchHeroes()
        
        multiSelectionTableView.dataSource = multiSelectionDataSource
        multiSelectionTableView.allItemsContentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        multiSelectionTableView.selectedItemsContentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
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

extension HeroesViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
}

