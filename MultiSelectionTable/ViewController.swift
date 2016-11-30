//
//  ViewController.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 28/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var multiSelectionTableControl: MultiSelectionTableControl!
    
    fileprivate var allAlbumIndexes: [Album] = [
        Album(band: Band(name: "Nirvana"), name: "Nevermind", cover: #imageLiteral(resourceName: "nevermind")),
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
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multiSelectionTableControl.allItems = allAlbumIndexes
    }
    
}
