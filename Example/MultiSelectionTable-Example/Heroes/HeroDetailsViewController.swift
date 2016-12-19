//
//  HeroDetailsViewController.swift
//  MultiSelectionTable-Example
//
//  Created by Nuno Gonçalves on 17/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class HeroDetailsViewController : UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heroImageView: UIImageView!

    @IBAction func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    var hero: Hero!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = hero.description
        
        Cache.ImageLoader().image(with: hero.imageURL) { image in
            self.heroImageView.image = image
        }
    }
    
}
