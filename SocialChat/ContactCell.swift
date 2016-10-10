//
//  ContactCell.swift
//  SocialChat
//
//  Created by zheng chai on 9/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    var added : [Bool]?
    var indexrow: Int?
    
    var friendId: String?
    
    @IBAction func addFriend(_ sender: AnyObject) {
        if friendId != nil{
            if myfirstName != nil && mylastName != nil && myusername != nil && myId != nil{
                let fullname = myfirstName! + " " + mylastName!
                DataService.instance.sendFriendRequest(senderId: myId!, senderUsername: myusername!, senderFullname: fullname, receiverId: friendId!, senderImageUrl: myimageUrl!)
            }

        }
        let alert = UIAlertController(title: "Send Request Successfully", message: "Tell your friend you've already sent the friend request!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nice", style: .cancel, handler: nil))
        //present(alert, animated: true, completion: nil)
        
        
        self.addFriend.isEnabled = false
        

        
    }
    @IBOutlet var addFriend: UIButton!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    

}
