//
//  AcceptRequestCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 09/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class AcceptRequestCell: UITableViewCell{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    private var senderId: String?
    
    
    func updateUI(sender: SenderInfo){
        
        self.profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        self.profileImage.clipsToBounds = true
        
        fullNameLabel.text = sender.fullName
        userNameLabel.text = sender.username
        timeLabel.text = sender.sendTime
        self.senderId = sender.uid
        if let url = URL(string: sender.imageUrl) {
            do {
                let data = try Data(contentsOf: url)
                self.profileImage.image = UIImage(data: data)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
    }

    @IBAction func acceptBtnPressed(_ sender: AnyObject) {
        
    }
}
