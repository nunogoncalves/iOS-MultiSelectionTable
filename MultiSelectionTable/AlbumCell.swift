//
//  AlbumCell.swift
//  MultiSelectionTable
//
//  Created by Nuno Gonçalves on 30/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit


class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var bottomLineHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomLineHeightConstraint.constant = 0.5
    }
}
