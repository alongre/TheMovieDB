//
//  ActorTableViewCell.swift
//  TheMovieDB
//
//  Created by Alon Green on 03/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class ActorTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var actorPoster: UIImageView!
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var characterName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        

        
    }


    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
