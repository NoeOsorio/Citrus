//
//  MenuClaseCell.swift
//  Citrus
//
//  Created by Noe Osorio on 02/08/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class MenuClaseCell: UITableViewCell {

    @IBOutlet var successButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var success: UIImageView!
    @IBOutlet var like: UIImageView!
    @IBOutlet var texto: UILabel!
    
    var likeBool:Bool = false
    var watchedBool:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction  func likeBtn(_ sender: Any) {
        ifLike()
        
    }
    @IBAction func successBtn(_ sender: Any) {
        ifWatched()
    }
    
    func ifLike(){
        if(likeBool){
            likeButton.isSelected = false
            likeBool = false
            
        }
        else{
            likeButton.isSelected = true
            likeBool = true
        }
    }
    
    func ifWatched(){
        if(watchedBool){
            successButton.isSelected = false
            watchedBool = false
            
        }
        else{
            successButton.isSelected = true
            watchedBool = true
        }
    }
    
    
}
