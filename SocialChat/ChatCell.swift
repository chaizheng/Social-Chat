//
//  ChatCell.swift
//  SocialChat
//
//  Created by zheng chai on 5/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    
    @IBOutlet var img: UIImageView!
    @IBOutlet var label: UILabel!
   // @IBOutlet var myImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(user: FriendInfo){
       
        label.text = user.firstName as String
        img.image = user.image
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        img.layer.borderWidth = 1.0
        img.layer.borderColor = DEFAULT_BLUE.cgColor
    }

}
