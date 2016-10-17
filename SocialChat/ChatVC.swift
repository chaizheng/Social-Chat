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
    
    

    //let defualtNum = "0000000000"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var backToCameraBtn: UIButton!
    
    private var senders = [FriendInfo]()
    private var uid = [String]()
    var searchController = UISearchController(searchResultsController: nil)
    var filteredSenders = [FriendInfo]()
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
      
        filteredSenders = senders.filter{
            friend in
            return friend.firstName.contains(searchText.lowercased())
            }
        tableView.reloadData()
    
}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        self.tableView.reloadData()

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
                    
                    
                    let newUid = receivedMsg["senderId"] as! String
                   
                    let name = receivedMsg["senderName"] as? String
                    print("receive"+name!)

                    
                    var newUser = FriendInfo(uid: newUid, fullName: name!, firstName: name!, image: #imageLiteral(resourceName: "default_user"))
                    if allFriendsInfo.count != 0{
                         newUser = self.findFriendById(uid: newUid)
                    } else {
                        
                    }
                    
                                       
                    
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
        if(self.searchController.isActive){
            return self.filteredSenders.count
        }else{
            return senders.count

        }
            }
    //传头像需要改结构
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
      
         let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        let friend: FriendInfo
        if searchController.isActive && searchController.searchBar.text != nil{
            print("woCaoNM")
            print(filteredSenders.count)
            friend = filteredSenders[indexPath.row]
            print("woCao")
            print(friend)
            cell.updateUI(user: friend)
            return cell
        }else{
            friend = senders[indexPath.row]
            cell.updateUI(user: friend)
            return cell
        }
        

        //return cell
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
    
    
//    public func updateSearchResults(for searchController: UISearchController){
//        filteredSenders.removeAll(keepingCapacity: false)
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        let array = (uid as NSArray).filtered(using: searchPredicate)
//        filteredTableData = array as! [String]
//        
//        self.tableView.reloadData()
//
//    }
    
    
}


extension ChatVC: UISearchResultsUpdating{
     func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        print(searchController.searchBar.text)
        print("hello")
    }
}
