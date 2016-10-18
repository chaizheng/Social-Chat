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
    var searchController = UISearchController(searchResultsController: nil)
    var filteredFriends = [FriendInfo]()
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        
        filteredFriends = allFriendsInfo.filter{
            friend in
            return friend.firstName.contains(searchText.lowercased())
        }
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        tableView.tableFooterView = UIView()
        AuthService.instance.updateLocalFriendsList()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCell
        cell.delegate = self
        let friend: FriendInfo
        if searchController.isActive && searchController.searchBar.text != nil{
            
            friend = filteredFriends[indexPath.row]
            cell.updateCell(friend: friend)
            
            return cell
        }else{
            friend = allFriendsInfo[indexPath.row]
            cell.updateCell(friend: friend)
            return cell
        }

       // return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.searchController.isActive){
            return self.filteredFriends.count
        }else{
            return allFriendsInfo.count

            
        }
        
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

}

extension FriendsVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
