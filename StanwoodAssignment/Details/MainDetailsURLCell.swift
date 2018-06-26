//
//  MainDetailsURLCell.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import UIKit

class MainDetailsURLCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
