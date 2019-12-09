//
//  ViewController.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 28/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit
import MultiSelectionTableView

class AlbunsViewController: UIViewController {

    @IBOutlet weak var multiSelectionTableContainer: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var multiSelectionDataSource: MultiSelectionDataSource<Album>!
    @IBOutlet fileprivate weak var multiSelectionTableView: MultiSelectionTableView!
    
    fileprivate var filteredAlbuns: [Album] = [] {
        didSet {
            multiSelectionDataSource.allItems = filteredAlbuns
        }
    }
    fileprivate var allAlbums: [Album] = []
    
    @IBAction func clearSearchText() {
        searchTextField.text = nil
        searchTextField.resignFirstResponder()
        filteredAlbuns = allAlbums
    }
    
    @IBAction func textUpdated(_ sender: UITextField) {
        if let searchText = sender.text,
            searchText.count > 0 {
            filteredAlbuns = allAlbums.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredAlbuns = allAlbums
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        multiSelectionDataSource = MultiSelectionDataSource(multiSelectionTableView: multiSelectionTableView)
        multiSelectionDataSource.delegate = self
        multiSelectionDataSource.register(nib: UINib(nibName: "AlbumCell", bundle: nil), for: "AlbumCell")
        
        Album.all { [weak self] albums in
            self?.allAlbums = albums
            self?.multiSelectionDataSource.allItems = albums
        }
        
        multiSelectionTableView.dataSource = multiSelectionDataSource
        multiSelectionTableView.allItemsContentInset = UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0)
        multiSelectionTableView.selectedItemsContentInset = UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0)
        multiSelectionTableView.addTarget(self, action: #selector(selectedItem(multiSelectionTableView:)), for: .itemSelected)
        multiSelectionTableView.addTarget(self, action: #selector(unselectedItem(multiSelectionTableView:)), for: .itemUnselected)
    }
    
    @objc private func selectedItem(multiSelectionTableView: MultiSelectionTableView) {
        print("selected item")
    }
    
    @objc private func unselectedItem(multiSelectionTableView: MultiSelectionTableView) {
        print("unselected item")
    }
}

extension AlbunsViewController : MultiSelectionTableDelegate {
    
    func paint(_ cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView, with item: Any) {
        if let cell = cell as? AlbumCell,
            let album = item as? Album {
            cell.nameLabel.text = album.band.name
            cell.subtitleLabel.text = album.name
            cell.yearLabel.text = "\(album.year)"

            let image = UIImage(named: album.coverImageName)
            cell.albumImageView.image = image
        }
    }
}

extension AlbunsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
