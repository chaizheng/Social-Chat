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
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var visibleTime: Int!
    var senderId: String!
    var storyUrl: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateCell(info: StoryInfo, profileImage: UIImage){
        
        self.profileImage.layer.cornerRadius = 25
        self.profileImage.clipsToBounds = true
        
        self.profileImage.image = profileImage
        self.firstNameLabel.text = info.firstName
        self.timeLabel.text = info.sendTime
        self.visibleTime = info.visibleTime
        self.senderId = info.uid
        self.storyUrl = info.storyUrl
    }

}
