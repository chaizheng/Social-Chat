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
    
    var refreshControl: UIRefreshControl!

    let defualtNum = "0000000000"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var backToCameraBtn: UIButton!
    
    private var senders = [FriendInfo]()
    private var uid = [String]()
    //private var chatInfo = [(String, UIImage)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

        self.tableView.delegate = self
        self.tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(Refresh), for: UIControlEvents.valueChanged)
        refreshControl.backgroundColor = UIColor.black
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
        self.tableView.reloadData()

    }
    func Refresh(){
       
        if self.refreshControl.isRefreshing{
            refreshControl.endRefreshing()
             self.tableView.reloadData()

        }
            }
    func findFriendById(uid: String) -> FriendInfo{
        if allFriendsInfo != nil{
            for k in allFriendsInfo{
                if k.uid == uid{
                    return k
                }
                
            }

        }
                return allFriendsInfo[0]
        
    }

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        var receivIndex = -1
        var sentIndex = -1
        
       
            let userId = FIRAuth.auth()!.currentUser?.uid
            DataService.instance.usersRef.child(userId!).child("receivedMessage").observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
                if let receivedMsg = snapshot.value as? Dictionary<String, Any>{
                    
                    print("chai")
                    let newUid = receivedMsg["senderId"] as! String
                   // print(newUid)
                    let name = receivedMsg["senderName"] as? String
                    print("receive"+name!)
//                    do{
//                        let imageUrl = receivedMsg["sender"]
//                        let url = URL(string: imageUrl)
//                        let data = try Data(contentsOf: url!)
//                        let picture = UIImage(data: data)
//
//                    }catch{
//                        print(error.localizedDescription)
//
//                    }
                                        print("fuck1")
                    var newUser = FriendInfo(uid: newUid, fullName: name!, firstName: name!, image: #imageLiteral(resourceName: "default_user"))
                    if allFriendsInfo.count != 0{
                         newUser = self.findFriendById(uid: newUid)
                    } else {
                        
                    }
                    
                    print("fuck2")
                    print(self.senders)
                    
                    
                    if self.uid.contains(newUid){
                        receivIndex = self.uid.index(of: newUid)!
                       
                        self.senders.remove(at: receivIndex)
                        self.uid.remove(at: receivIndex)
                        
                        self.senders.insert(newUser, at: 0)
                        self.uid.insert(newUid, at: 0)
                        print("sb1")
                        print(self.senders)
                       
                    } else{
                        //self.senders.append(newUser)
                        
                        self.senders.insert(newUser, at: 0)
                        self.uid.insert(newUid, at: 0)
                        //receivIndex = self.uid.index(of: newUid)!
                        print("sb2")
                    print(self.senders)
                        
                        
                    }
                    self.tableView.reloadData()
                    
                }
                //self.tableView.reloadData()
                
            }
            DataService.instance.usersRef.child(userId!).child("sentMessage").observe(.childAdded){ (snapshot: FIRDataSnapshot!) in
                if let sentMsg = snapshot.value as? Dictionary<String, Any>{
                    
                    
                    let name = sentMsg["receiverName"] as? String
                    let newUid = sentMsg["receiverId"] as? String

                    
                    print("sent"+name!)
                    
                    //let newUser = self.findFriendById(uid: newUid!)
                    var newUser = FriendInfo(uid: newUid!, fullName: name!, firstName: name!, image: #imageLiteral(resourceName: "default_user"))
                    if allFriendsInfo.count != 0{
                         newUser = self.findFriendById(uid: newUid!)
                    } else {
                        
                    }
                    
                    
                    if self.uid.contains(newUid!){
                        sentIndex = self.uid.index(of: newUid!)!
                        self.senders.remove(at: sentIndex)
                        self.uid.remove(at: sentIndex)
                        self.senders.insert(newUser, at: 0)
                        self.uid.insert(newUid!, at: 0)
                        print("sb3")
                        print(self.senders)
                        
                    } else{
                        //self.senders.append(newUser)
                        self.senders.insert(newUser, at: 0)
                        //sentIndex = self.uid.index(of: newUid!)!
                        self.uid.insert(newUid!, at: 0)
                        print("sb4")
                        print(self.senders)
                        
                       
                        

                    }

                    
                    self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = senders[indexPath.row]
        performSegue(withIdentifier: "SendVC", sender: user )
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendVC" {
            let navigController = segue.destination as! UINavigationController
            let sendVC = navigController.topViewController as! SendVC
            if let receiverInfo = sender as? FriendInfo{
                sendVC.receiverId = receiverInfo.uid
                sendVC.recieverName = receiverInfo.firstName
            }
            
        }
    }
    
    
}
