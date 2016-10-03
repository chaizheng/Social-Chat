//
//  UserInfoVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/14/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import Firebase

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var fullname: UILabel!
    let userID = FIRAuth.auth()?.currentUser?.uid

    override func viewDidAppear(_ animated: Bool) {
        profileImage.layer.cornerRadius = 90
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor(red: 35/255, green: 187/255, blue: 245/255, alpha: 1).cgColor
        profileImage.clipsToBounds = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.instance.usersRef.child(userID!).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
        let value = snapshot.value as? Dictionary<String, Any>
        let firstname = value?["firstName"] as! String
        let lastname = value?["lastName"] as! String
        self.fullname.text = firstname + " " + lastname
        self.username.text = value?["username"] as? String
        if let url = URL(string: value?["imageUrl"] as! String) {
            do {
              let data = try Data(contentsOf: url)
              self.profileImage.image = UIImage(data: data)
            }
            catch{
                print(error.localizedDescription)
            }
        }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
