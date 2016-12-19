//
//  HeroCell.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 09/12/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class HeroCell: UITableViewCell {

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBAction func infoTapped() {
        showInfo?()
    }
    
    var showInfo: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        heroImageView.image = nil
        bottomLine.isHidden = false
    }
    
}
