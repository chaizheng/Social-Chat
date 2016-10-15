//
//  UsersVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//
//
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var send_Btn: UIBarButtonItem!
    
    private var selectedFriends = Dictionary<String, FriendInfo>()
    
    private var _image: UIImage!
    private var _visibleTime = 5
    
    
    var visibleTime:Int{
        get{
            return _visibleTime
        } set{
            _visibleTime = newValue
        }
    }
    
    var image:UIImage{
        get{
            return _image
        } set{
            _image = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        send_Btn.isEnabled = false
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let friend = allFriendsInfo[indexPath.row]
        cell.updateUI(friend: friend)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        send_Btn.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let friend = allFriendsInfo[indexPath.row]
        selectedFriends[friend.uid] = friend
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let friend = allFriendsInfo[indexPath.row]
        selectedFriends[friend.uid] = nil
        
        if selectedFriends.count < 1{
            send_Btn.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Friends"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)!
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = NSTextAlignment.center
        header.contentView.backgroundColor = DEFAULT_BLUE
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allFriendsInfo.count
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func sendBtnPressed(_ sender: AnyObject) {
        
        let filePath = "\(myId!)/\(Date.timeIntervalSinceReferenceDate)"
        let ref = DataService.instance.imageStorageRef.child(filePath)
        
        let data = UIImageJPEGRepresentation(image, 0.5)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        
        ref.put(data!, metadata: metadata) { (metadata, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            let imageUrl = metadata!.downloadURLs![0].absoluteString
            
            for friend in self.selectedFriends{
                DataService.instance.sendMessage(messageType: "VISIIMAGE", content: imageUrl, senderId: myId!, senderName: myfirstName!, receiverId: friend.key,receiverName: friend.value.firstName,senderImageUrl: myimageUrl!,visibleTime: self.visibleTime)
    
            }
        }
        dismiss(animated: false, completion: nil)
    }
        
}

