//
//  MovieTableViewCell.swift
//  TheMovieDB
//
//  Created by Alon Green on 07/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //MARK: -> Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
