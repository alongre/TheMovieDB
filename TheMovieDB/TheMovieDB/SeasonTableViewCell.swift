//
//  SeasonTableViewCell.swift
//  TheMovieDB
//
//  Created by Alon Green on 24/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class SeasonTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var seasonNumberLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
