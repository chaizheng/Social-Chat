//
//  AcceptRequestCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 09/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit


protocol CustomCellCallsDelegate{
    func showAlertAndReload(tag: Int, name: String)
}

class AcceptRequestCell: UITableViewCell{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    private var senderId: String?
    private var senderFullName: String?
    var delegate: CustomCellCallsDelegate?
    
    
    func updateCell(sender: SenderInfo){
        
        self.profileImage.layer.cornerRadius = 35
        self.profileImage.clipsToBounds = true
        
        fullNameLabel.text = sender.fullName
        userNameLabel.text = sender.username
        timeLabel.text = sender.sendTime
        self.senderId = sender.uid
        self.senderFullName = sender.fullName
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
        let requestRef = "\(senderId!)-\(myId!)"
        let myfullName = myfirstName! + " " + mylastName!
        let senderInfo: Dictionary<String, Any> = [senderId!:senderFullName!]
        let receiverInfo: Dictionary<String, Any> = [myId!:myfullName]
        
        //Delete sender request in sender database and add "ME" in his friends list
        DataService.instance.usersRef.child(senderId!).child("sentFriendRequest").child(requestRef).setValue(nil)
        DataService.instance.usersRef.child(senderId!).child("friends").updateChildValues(receiverInfo)
        
        //Delete my received request in my database and add "HIM" in my friends list
        DataService.instance.usersRef.child(myId!).child("receivedFriendRequest").child(requestRef).setValue(nil)
        DataService.instance.usersRef.child(myId!).child("friends").updateChildValues(senderInfo)
        
        self.delegate?.showAlertAndReload(tag: self.tag, name: senderFullName!)
        
        //update myfriends list
        AuthService.instance.updateLocalFriendsList()
    }
}
