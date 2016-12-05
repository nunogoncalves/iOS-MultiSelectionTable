//
//  ViewController.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 28/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var multiSelectionTableContainer: UIStackView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var multiSelectionDataSource: MultiSelectionDataSource<Album>!
    @IBOutlet fileprivate weak var multiSelectionTableView: MultiSelectionTableView!
    
    fileprivate var filteredAlbuns: [Album] = []
    
    fileprivate var allAlbums: [Album] = [
        Album(band: Band(name: "Nirvana"), name: "Nevermind", cover: #imageLiteral(resourceName: "nevermind"), year: 1991),
        Album(band: Band(name: "Red Hot Chili Peppers"), name: "Californication", cover: #imageLiteral(resourceName: "californication"), year: 1999),
        Album(band: Band(name: "BloodHound Gang"), name: "Hoorray for boobies", cover: #imageLiteral(resourceName: "badadchaseylane"), year: 1999),
        Album(band: Band(name: "Limp Bizkit"), name: "Three Dollar Bill Yall", cover: #imageLiteral(resourceName: "threedollarbillyall"), year: 1997),
        Album(band: Band(name: "Metallica"), name: "S&M", cover: #imageLiteral(resourceName: "s&m"), year: 1999),
        Album(band: Band(name: "Roxette"), name: "Joyride", cover: #imageLiteral(resourceName: "joyride"), year: 1991),
        Album(band: Band(name: "U2"), name: "Best of", cover: #imageLiteral(resourceName: "u2bestof"), year: 1998),
        Album(band: Band(name: "Queen"), name: "Greatest Hits 2", cover: #imageLiteral(resourceName: "queengreatest2"), year: 1991),
        Album(band: Band(name: "Pink"), name: "I'm not dead", cover: #imageLiteral(resourceName: "imnotdead"), year: 2006),
        Album(band: Band(name: "Guns N Roses"), name: "Appetite for Destruction", cover: #imageLiteral(resourceName: "appetite-for-destruction"), year: 1987),
        Album(band: Band(name: "AC/DC"), name: "Black Ice", cover: #imageLiteral(resourceName: "blackice"), year: 2008),
        Album(band: Band(name: "Pink Floyd"), name: "Dark Side of the Moon", cover: #imageLiteral(resourceName: "Dark_Side_of_the_Moon"), year: 1973),
        Album(band: Band(name: "Eurytmics"), name: "Touch", cover: #imageLiteral(resourceName: "Eurythmics_-_Touch"), year: 1983),
        Album(band: Band(name: "Coldplay"), name: "Ghosts of Stories", cover: #imageLiteral(resourceName: "ghoststoriesfull"), year: 2014),
        Album(band: Band(name: "Pink"), name: "Funhouse", cover: #imageLiteral(resourceName: "funhouse"), year: 2008),
        Album(band: Band(name: "Bon Jovi"), name: "It's My Life", cover: #imageLiteral(resourceName: "itsmylife"), year: 2000),
        Album(band: Band(name: "Ramstein"), name: "Rosenrot", cover: #imageLiteral(resourceName: "rosenrot"), year: 2005),
        Album(band: Band(name: "Michael Jackson"), name: "Thriller", cover: #imageLiteral(resourceName: "thriller"), year: 1982),
        Album(band: Band(name: "INXS"), name: "Switch", cover: #imageLiteral(resourceName: "switch"), year: 2005),
    ]
    
    @IBAction func textUpdated(_ sender: UITextField) {
        if let searchText = sender.text,
            searchText.characters.count > 0 {
            filteredAlbuns = allAlbums.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredAlbuns = allAlbums
        }
        multiSelectionDataSource.allItems = filteredAlbuns
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        multiSelectionTableView.seperatorWidthOffset = 130
      
        multiSelectionDataSource = MultiSelectionDataSource(multiSelectionTableView: multiSelectionTableView)
        multiSelectionDataSource.delegate = self
        multiSelectionDataSource.register(nib: UINib(nibName: "AlbumCell", bundle: nil), for: "AlbumCell")
        
        multiSelectionDataSource.allItems = allAlbums
        
        multiSelectionTableView.dataSource = multiSelectionDataSource
    }
    
}

extension ViewController : MultiSelectionTableDelegate {
    
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
