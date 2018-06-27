//
//  MainCVCell.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import UIKit

protocol MainCVCellDelegate: class {
    func didPressStarButton(_ sender: UIButton)
}

class MainCVCell: UICollectionViewCell {
    
    weak var delegate: MainCVCellDelegate?
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var startsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        
        if starButton.isSelected == true {
            starButton.isSelected = false
        }else {
            starButton.isSelected = true
        }
        delegate?.didPressStarButton(starButton)
    }
}
