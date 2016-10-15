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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateCell(firstName: String, time: String, profileImage: UIImage){
        
        self.profileImage.layer.cornerRadius = 25
        self.profileImage.clipsToBounds = true
        
        self.profileImage.image = profileImage
        self.firstNameLabel.text = firstName
        self.timeLabel.text = time
    }

}
