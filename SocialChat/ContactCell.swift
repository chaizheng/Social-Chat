//
//  ContactCell.swift
//  SocialChat
//
//  Created by zheng chai on 9/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBAction func AddFriend(_ sender: AnyObject) {
    }
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
