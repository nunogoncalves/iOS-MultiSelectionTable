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
    @IBOutlet weak var searchTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var multiSelectionDataSource: MultiSelectionDataSource<Hero>!
    @IBOutlet fileprivate weak var multiSelectionTableView: MultiSelectionTableView!

    fileprivate lazy var mainStoryboard: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()
    
    @IBAction func clearSearchText() {
        searchTextField.text = nil
        searchTextField.resignFirstResponder()
        searchText = ""
    }
    
    fileprivate var searchText = "" {
        didSet {
            multiSelectionDataSource.allItems = []
            searchHeroes()
        }
    }
    
    fileprivate func searchHeroes(in page: Int = 0) {
        guard !isLoading else { return }
        
        if page == 0 {
            let loadingView = UIActivityIndicatorView()
            loadingView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
            loadingView.startAnimating()
            multiSelectionTableView.stateView = loadingView
        }
        isLoading = true
        Hero.all(named: searchText, in: page) { [weak self] heroesList in
            self?.multiSelectionTableView.stateView = nil
            self?.heroesList = heroesList
            self?.isLoading = false
        }
    }
    
    fileprivate var heroesList: HeroesList = HeroesList.emptyHeroesList {
        didSet {
            if heroesList.isFirstPage {
                multiSelectionDataSource.allItems = heroesList.heroes
            } else {
                multiSelectionDataSource.allItems.append(contentsOf: heroesList.heroes)
            }
            if heroesList.heroes.count <= 1 {
                let label = UILabel()
                label.text = "No heroes"
                label.textColor = .white
                label.textAlignment = .center
                multiSelectionTableView.stateView = label
            }
        }
    }
    
    fileprivate let imageLoader = Cache.ImageLoader.shared
    
    fileprivate var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multiSelectionDataSource = MultiSelectionDataSource(multiSelectionTableView: multiSelectionTableView)
        multiSelectionDataSource.delegate = self
        multiSelectionDataSource.register(nib: UINib(nibName: "HeroCell", bundle: nil), for: "HeroCell")
        
        multiSelectionDataSource.allItems = heroesList.heroes
        searchHeroes()
        
        multiSelectionTableView.dataSource = multiSelectionDataSource
        multiSelectionTableView.allItemsContentInset = UIEdgeInsets(top: 105, left: 0, bottom: 0, right: 0)
        multiSelectionTableView.selectedItemsContentInset = UIEdgeInsets(top: 105, left: 0, bottom: 0, right: 0)
        multiSelectionTableView.supportsPagination = true
        multiSelectionTableView.paginationNotificationRowIndex = 20
        multiSelectionTableView.cellAnimator = CellSelectionPulseAnimator(pulseColor: .black)
        multiSelectionTableView.cellTransitioner = SuperManAnimator()
        
        multiSelectionTableView.addTarget(self, action: #selector(loadMoreHeroes(multiSelectionTableView:)), for: .scrollReachingEnd)
    }
    
    @objc private func loadMoreHeroes(multiSelectionTableView: MultiSelectionTableView) {
        if heroesList.hasMorePages {
            searchHeroes(in: heroesList.currentPage + 1)
        }
    }
    
}

extension HeroesViewController : MultiSelectionTableDelegate {
    
    func paint(
        _ cell: UITableViewCell,
        at indexPath: IndexPath,
        in tableView: UITableView, with item: Any
    ) {
        if let cell = cell as? HeroCell,
            let hero = item as? Hero {
            cell.heroNameLabel.text = hero.name
            if let image = imageLoader.cachedImage(with: hero.imageURL) {
                cell.heroImageView.image = image
            } else {
                imageLoader.image(with: hero.imageURL) { image in
                    if let cell = tableView.cellForRow(at: indexPath) as? HeroCell {
                        cell.heroImageView.image = image
                    }
                }
            }
            
            cell.showInfo = { [weak self] in
                if let heroViewController = self?.mainStoryboard.instantiateViewController(withIdentifier: "HeroDetailsViewController") as? HeroDetailsViewController {
                    heroViewController.hero = hero
                    self?.show(heroViewController, sender: self)
                }
            }
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

