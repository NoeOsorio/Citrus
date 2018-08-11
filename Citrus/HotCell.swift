//
//  HotCell.swift
//  Citrus
//
//  Created by Noe Osorio on 19/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class HotCell: UITableViewCell {

    @IBOutlet var bgimage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var content: UITextView!
    
    var contentDicc:[String:String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
