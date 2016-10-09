//
//  AddByUsernameVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 08/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddByUsernameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: RoundTextField!
    
    @IBOutlet weak var foundView: UIView!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    var friendId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = DEFAULT_BLUE
        usernameField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImage.layer.cornerRadius = 60
        profileImage.clipsToBounds = true
        self.foundView.layer.borderWidth = 1
        self.foundView.layer.borderColor = DEFAULT_BLUE.cgColor
        self.notFoundView.layer.borderWidth = 3
        self.notFoundView.layer.borderColor = DEFAULT_BLUE.cgColor
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchBtnPressed(_ sender: AnyObject) {
        
        usernameField.resignFirstResponder()
        self.foundView.isHidden = true
        self.notFoundView.isHidden = true
        if let username = usernameField.text, username.characters.count > 0{
//            if username == myusername{
//                let alert = UIAlertController(title: "Invalid Username", message: "This is your username", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                present(alert, animated: true, completion: nil)
//                return
//            }
            DataService.instance.mainRef.child("Username").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
                    if let value = snapshot.value as? Dictionary<String, Any> {
                        var findItem = false
                        for item in value{
                            if item.value as? String == username{
                                findItem = true
                                DataService.instance.usersRef.child(item.key).child("profile").observeSingleEvent(of: .value, with: { (usersnapshot) -> Void in
                                    if let userValue = usersnapshot.value as? Dictionary<String, Any> {
                                        let firstName = userValue["firstName"] as? String
                                        let lastName = userValue["lastName"] as? String
                                        self.fullNameLabel.text = firstName! + " " + lastName!
                                        self.usernameLabel.text = item.value as? String
                                        self.friendId = item.key
                                        if let url = URL(string: userValue["imageUrl"] as! String) {
                                            do {
                                                let data = try Data(contentsOf: url)
                                                self.profileImage.image = UIImage(data: data)
                                            }
                                            catch{
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                })
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    self.foundView.isHidden = false
                                })
                                break
                            }
                        }
                        if !findItem {
                            self.notFoundView.isHidden = false
                        }
                        
                    }
            })

        } else{
            let alert = UIAlertController(title: "Invalid Username", message: "You must enter username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
 
        }
        
    }
    @IBAction func addFriendBtnPressed(_ sender: AnyObject) {
        if let friendId = self.friendId{
            if myfirstName != nil && mylastName != nil && myusername != nil && myId != nil{
                let fullname = myfirstName! + " " + mylastName!
                DataService.instance.sendFriendRequest(senderId: myId!, senderUsername: myusername!, senderFullname: fullname, receiverId: friendId)
            }
        }
        let alert = UIAlertController(title: "Send Request Successfully", message: "Tell your friend you've already sent the friend request!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nice", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        self.foundView.isHidden = true
        return
    }
}
