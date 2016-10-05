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
    private var users = [User]()
    private var selectedUsers = Dictionary<String, User>()
    private var _image: UIImage?
    var imgVisibleTime:Int = 5
    
    var image:UIImage?{
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
        // Do any additional setup after loading the view.
        send_Btn.isEnabled = false
        
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if let users = snapshot.value as? Dictionary<String, Any>{
                for(key, value) in users{
                    if let dict = value as? Dictionary<String, Any> {
                        if let profile = dict["profile"] as? Dictionary<String, Any> {
                            if let firstName = profile["firstName"] as? String{
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                        }
                    }}
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        send_Btn.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        if selectedUsers.count < 1{
            send_Btn.isEnabled = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    @IBAction func sendBtnPressed(_ sender: AnyObject) {
//        if let image = _image{
//            let imageName = "\(NSUUID().uuidString).jpg"
//            let ref = DataService.instance.imageStorageRef.child(imageName)
//            let imageData:Data = UIImageJPEGRepresentation(image, CGFloat(0.5))!
//            _ = ref.put(imageData, metadata: nil, completion: { (meta:FIRStorageMetadata?, err:Error?) in
//                if err != nil{
//                    print("Error uploading image: \(err?.localizedDescription)")
//                } else {
//                    
//                    let downloadURL = meta!.downloadURLs[0].absoluteString
//                    for receiver in self.selectedUsers{
//                        DataService.instance.sendMessage(messageType: "PHOTO", content: downloadURL, senderId: FIRAuth.auth()!.currentUser!.uid, senderName: <#T##String#>, receiverId: receiver.key)
//                    }
//                    let downloadURL = meta!.downloadURL()
//                    DataService.instance.sendMediaPullRequest(senderUID: FIRAuth.auth()!.currentUser!.uid, sendingTo: self.selectedUsers, mediaURL: downloadURL!, visibleTime: self.imgVisibleTime)
//                    let downloadURL = meta!.downloadURLs[0].absoluteString
//                    DataService.instance.sendMessage(messageType: "PHOTO", content: downloadURL, senderId: <#T##String#>, senderName: <#T##String#>, receiverId: <#T##String#>)
//                }
//            })
//            let resultViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
//            self.present(resultViewController, animated: false, completion: nil)
        }
        
        
        
        
        
        
        
        
        
        
        
        
}

