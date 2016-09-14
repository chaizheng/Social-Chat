//
//  UsersVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//
//
//import UIKit
//import FirebaseDatabase
//
//class UsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.allowsMultipleSelection = true
//        // Do any additional setup after loading the view.
//        
//        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
//            if let users = snapshot.value as? Dictionary<String, Any>{
//                for(key, value) in users{
//                    if let dict = value as? Dictionary<String, Any> {
//                        if let profile = dict["profile"] as? Dictionary<String, Any> {
//                            if let 
//                        }
//                    }}
//            }
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
//        let user = users[indexPath.row]
//        cell.updataUI(user:user)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! UserCell
//        cell.setCheckmark(selected: true)
//        
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        
//    
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//}
