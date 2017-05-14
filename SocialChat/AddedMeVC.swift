//
//  AddedMeVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 09/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import Firebase

class AddedMeVC: UIViewController,UITableViewDataSource, UITableViewDelegate, CustomCellCallsDelegate {

    @IBOutlet weak var tableView: UITableView!
    private var senders = [SenderInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        DataService.instance.selfRef.child("receivedFriendRequest").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for childSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                if let value = childSnapshot.value as? Dictionary<String, Any> {
                    let sendTime = value["sendTime"] as! String
                    let senderFullName = value["senderFullname"] as! String
                    let senderUsername = value["senderUsername"] as! String
                    let senderImageUrl = value["senderImageUrl"] as! String
                    let senderId = value["senderId"] as! String
                    
                    let sender = SenderInfo(uid: senderId, fullName: senderFullName, sendTime: sendTime, imageUrl: senderImageUrl, username: senderUsername)
                    self.senders.append(sender)
            }
        }
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptRequestCell") as! AcceptRequestCell
        let sender = senders[indexPath.row]
        cell.updateCell(sender: sender)
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senders.count
    }

    @IBAction func backBtnPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
    
    
    func showAlertAndReload(tag: Int, name: String) {
        
        let alert = UIAlertController(title: "Add Successfully", message: "\(name) is your friend now!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great", style: .cancel, handler: nil))
        senders.remove(at: tag)
        if senders.count == 0{
            self.tableView.isHidden = true
        } else{
            self.tableView.reloadData()
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
