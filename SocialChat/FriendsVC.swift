//
//  FriendsVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 10/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,FriendCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(allFriendsInfo[0].firstName)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCell
        let friend = allFriendsInfo[indexPath.row]
        cell.updateCell(friend: friend)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFriendsInfo.count
    }
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
    
    func toSendVC(receiverId: String, receiverName: String) {
        let user = User(uid: receiverId, firstName: receiverName)
        performSegue(withIdentifier: "SendVC", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendVC" {
            let navigController = segue.destination as! UINavigationController
            let sendVC = navigController.topViewController as! SendVC
            if let receiverInfo = sender as? User{
                sendVC.receiverId = receiverInfo.uid
                sendVC.recieverName = receiverInfo.firstName
            }
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
