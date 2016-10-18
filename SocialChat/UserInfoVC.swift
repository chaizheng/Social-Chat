//
//  UserInfoVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/14/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

let DEFAULT_BLUE: UIColor = UIColor(red: 35/255, green: 187/255, blue: 245/255, alpha: 1)

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var newReminder: UIImageView!
    
    let userID = FIRAuth.auth()?.currentUser?.uid
    

    override func viewDidAppear(_ animated: Bool) {
        profileImage.layer.cornerRadius = 90
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = DEFAULT_BLUE.cgColor
        profileImage.clipsToBounds = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check but not entering now
        if myusername != nil && mylastName != nil && myfirstName != nil && myimageUrl != nil{
            self.fullname.text = myfirstName! + " " + mylastName!
            self.username.text = myusername
            let url = URL(string: myimageUrl!)
                do {
                    let data = try Data(contentsOf: url!)
                    self.profileImage.image = UIImage(data: data)
                }
                catch{
                    print(error.localizedDescription)
                }
        }
        else{
            DataService.instance.usersRef.child(userID!).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? Dictionary<String, Any> {
                    let firstname = value["firstName"] as! String
                    let lastname = value["lastName"] as! String
                    self.fullname.text = firstname + " " + lastname
                    self.username.text = value["username"] as? String
                    let url = URL(string: value["imageUrl"] as! String)
                    self.asyn(url: url!)
                }
            })
            DataService.instance.selfRef.child("receivedFriendRequest").observe(.childAdded, with: {(snapshot) in
                self.newReminder.isHidden = false
            })
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.newReminder.isHidden = true
    }
    
    func asyn(url: URL){
        let downloader = SDWebImageDownloader.shared()
       _ = downloader?.downloadImage(with: url, options: [], progress: nil, completed: {
            (image,data,error,finished) in
            print(Thread.current)
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        })
    }

}
