//
//  UserCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCheckmark(selected: Bool) {
        let imageStr = selected ? "checkedBox" : "checkBox"
        self.accessoryView = UIImageView(image: UIImage(named: imageStr))
    }
    


}
