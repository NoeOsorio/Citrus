//
//  LectureCell.swift
//  EduTest
//
//  Created by Noe Osorio on 07/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class LectureCell: UITableViewCell {
 
    
    @IBOutlet var texto: UITextView!
    @IBOutlet var subtitulo: UILabel!
    @IBOutlet var imagen: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
