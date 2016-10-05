//
//  ChatCell.swift
//  SocialChat
//
//  Created by zheng chai on 5/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

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
    
    func updateUI(user: User){
       
        label.text = user.firstName as String
    }

}
