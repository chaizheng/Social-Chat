//
//  StoryTableCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 11/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class StoryTableCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
