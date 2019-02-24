//
//  MovieCell.swift
//  flixter
//
//  Created by Hunter Boleman on 2/21/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var synopsisLable: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
