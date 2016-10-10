//
//  FriendCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 10/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

protocol FriendCellDelegate {
    func toSendVC(receiverId: String, receiverName: String)
}

class FriendCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    var friendFirstName: String?
    var friendId: String?
    var delegate: FriendCellDelegate?
    
    func updateCell(friend: FriendInfo){
        
        self.profileImage.layer.cornerRadius = 28
        self.profileImage.clipsToBounds = true
        
        fullNameLabel.text = friend.fullName
        profileImage.image = friend.image
        friendFirstName = friend.firstName
        friendId = friend.uid
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBAction func chatBtnPressed(_ sender: AnyObject) {
        self.delegate?.toSendVC(receiverId: friendId!, receiverName: friendFirstName!)
    }

}
