//
//  MenuCell.swift
//  EduTest
//
//  Created by Noe Osorio on 06/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
         
        
    }

}
