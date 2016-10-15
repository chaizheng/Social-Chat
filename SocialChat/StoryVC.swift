//
//  StoryVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import FirebaseDatabase

var subscriptionSet = Set<String>()

class StoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var goToDisBtn: UIButton!
    @IBOutlet weak var backToCameraBtn: UIButton!
    @IBOutlet weak var storyCollectionView: UICollectionView!
    @IBOutlet weak var storyTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var receivedStories = [Dictionary<String, Any>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        storyTableView.delegate = self
        storyTableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(StoryVC.Refresh), for: UIControlEvents.valueChanged)
        refreshControl.backgroundColor = UIColor.white
        storyTableView.addSubview(refreshControl)
        
        storyTableView.tableFooterView = UIView()
        retrieveStories()
        
    }
    
    func retrieveStories(){
        DataService.instance.selfRef.child("receivedStories").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for childSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                if let value = childSnapshot.value as? Dictionary<String, Any> {
                    self.receivedStories.append(value)
                }
            }
            self.storyTableView.reloadData()
        }

    }
    
    
    func Refresh(){
        retrieveStories()
        refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Subscription part
        if indexPath.section == 0 {
            if subscriptionSet.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "nilValueCell") as! nilValueCell
                cell.updateCell(from: "StorySubscription")
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell") as! SubscriptionCell
            cell.updateCell(index: indexPath.row)
            return cell
            
        }
        // Story part
        else{
            if receivedStories.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "nilValueCell") as! nilValueCell
                cell.updateCell(from: "FriendStory")
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableCell") as! StoryTableCell
            let story = receivedStories[indexPath.row]
            cell.updateCell(firstName: story["senderName"] as! String , time: story["sendTime"] as! String, profileImageUrl: story["senderImageUrl"] as! String)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        
        if section == 0{
            return "Subsription"
        } else{
            return "Friend Stories"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)!
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = NSTextAlignment.center
        header.contentView.backgroundColor = DEFAULT_BLUE
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if subscriptionSet.count == 0{
                return 1
            }
            return subscriptionSet.count
            
        } else{
            if receivedStories.count == 0{
                return 1
            }
            return receivedStories.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showwebview", sender: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionCell", for: indexPath) as? StoryCollectionCell{
            
            cell.configureCell(web:webdiscover[indexPath.row], id: indexPath.row+1)
            return cell
            
        } else{
            return UICollectionViewCell()
        }

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 50
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebVC{
            if let index = sender as? Int {
                destination.selectedUrl = webdiscover[index].url
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func goToDisBtnPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goRight"), object: nil)
    }

    @IBAction func backToCameraBtnPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goLeft"), object: nil)
    }
  

}
