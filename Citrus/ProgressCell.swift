//
//  ProgressCell.swift
//  Citrus
//
//  Created by Noe Osorio on 07/08/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//
import MBCircularProgressBar
import UIKit

class ProgressCell: UITableViewCell {

    @IBOutlet var progress: MBCircularProgressBarView!
    @IBOutlet var title: UILabel!
    @IBOutlet var icon: UIImageView!
    
    var progressValue:CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if progressValue != nil{
            UIView.animate(withDuration: 10.0) {
                self.progress.value = self.progressValue!
            }
        }
        else{
            //progress.value = 0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
