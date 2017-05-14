//
//  nilValueCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 15/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class nilValueCell: UITableViewCell {

    @IBOutlet weak var noticeLabel: UILabel!
    
    @IBOutlet weak var reloadLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(from: String){

        switch from {
        case "StorySubscription":
            noticeLabel.text = "You haven't subscribed any channel😂"
            break
        case "FriendStory":
            noticeLabel.text = "None of your friends shared story😳 "
        default:
            break
        }
    }
    
    
    
}
