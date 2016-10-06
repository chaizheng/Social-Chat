//
//  ChatVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import Firebase


class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var backToCameraBtn: UIButton!
    
    private var senders = [User]()
    private var uid = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        for user in (self.senders){
            print("ss2"+user.firstName)
        }


    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        var receivIndex = -1
        var sentIndex = -1
        
        DispatchQueue.main.async{
            let userId = FIRAuth.auth()!.currentUser?.uid
            DataService.instance.usersRef.child(userId!).child("receivedMessage").observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
                if let receivedMsg = snapshot.value as? Dictionary<String, Any>{
                    
                    
                    let newUid = receivedMsg["senderId"] as! String
                    let name = receivedMsg["senderName"] as? String
                    print("receive"+name!)
                    let newUser = User(uid: newUid, firstName: name!)
                    
                    
                    if self.uid.contains(newUid){
                        self.senders.remove(at: receivIndex)
                        self.senders.insert(newUser, at: 0)
                        
                    } else{
                        self.senders.append(newUser)
                        self.uid.append(newUid)
                        
                        receivIndex = self.uid.index(of: newUid)!
                    }
                    
                    
                }
                //self.tableView.reloadData()
                
            }
            DataService.instance.usersRef.child(userId!).child("sentMessage").observe(.childAdded){ (snapshot: FIRDataSnapshot!) in
                if let sentMsg = snapshot.value as? Dictionary<String, Any>{
                    
                    let newUid = sentMsg["senderId"] as? String
                    let name = sentMsg["senderName"] as? String
                    print("sent"+name!)
                    let newUser = User(uid: newUid!, firstName: name!)
                    
                    if self.uid.contains(newUid!){
                        self.senders.remove(at: sentIndex)
                        self.senders.insert(newUser, at: 0)
                    } else{
                        self.senders.append(newUser)
                        self.uid.append(newUid!)
                        sentIndex = self.uid.index(of: newUid!)!

                    }

                    
                    self.tableView.reloadData()
                }
                
                           }

        }
        
        
       
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToCameraBtnPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goRight"), object: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return senders.count
    }
    //传头像需要改结构
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
      
         let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        let friend = senders[indexPath.row]
       
        cell.updateUI(user: friend)

        return cell
    }
    
    
}
