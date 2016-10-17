//
//  StoryVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

var subscriptionSet = Set<String>()

class StoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var goToDisBtn: UIButton!
    @IBOutlet weak var backToCameraBtn: UIButton!
    @IBOutlet weak var storyCollectionView: UICollectionView!
    @IBOutlet weak var storyTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var receivedStories = [Dictionary<String, Any>]()
    var storiesImage = [UIImage]()

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
        var downloadedStories = [Dictionary<String, Any>]()
        DataService.instance.selfRef.child("receivedStories").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for childSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                if let value = childSnapshot.value as? Dictionary<String, Any> {
                    downloadedStories.append(value)
                }
            }
            self.receivedStories = downloadedStories
        }
    }
    
    
    func Refresh(){
        
        for story in receivedStories{
            
            let storyUrl = story["storyUrl"] as! String
            let url = URL(string: storyUrl)
            let downloader = SDWebImageDownloader.shared()
            _ = downloader?.downloadImage(with: url, options: [], progress: nil, completed: {
                (image,data,error,finished) in
                DispatchQueue.main.async {
                    self.storiesImage.append(image!)
                }
            })
        }
        self.storyTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
            let currentCell = tableView.cellForRow(at: indexPath) as! SubscriptionCell
            performSegue(withIdentifier: "showwebview", sender: currentCell.channelName.text)
            
        }else if indexPath.section == 1{
            
//            let currentCell = tableView.cellForRow(at: indexPath) as! StoryTableCell
            let visibleTime = receivedStories[indexPath.row]["visibleTime"] as! String
            let info:Dictionary<String, Any> = ["visibleTime":visibleTime,"visibleImage":storiesImage[indexPath.row]]
            performSegue(withIdentifier: "PresentImageVC", sender: info)
            
            let sendTime = receivedStories[indexPath.row]["sendTime"] as! String
            let senderId = receivedStories[indexPath.row]["senderId"] as! String
            receivedStories.remove(at: indexPath.row)
            
            //Delete my received story in my database
            let storyRef = "\(senderId)-\(sendTime)"
            DataService.instance.usersRef.child(myId!).child("receivedStories").child(storyRef).setValue(nil)
            tableView.reloadData()
            
        }else{
            performSegue(withIdentifier: "showwebview", sender: "Live")
        }
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
        else if indexPath.section == 1{
            if receivedStories.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "nilValueCell") as! nilValueCell
                cell.updateCell(from: "FriendStory")
                return cell
            } else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableCell") as! StoryTableCell
                let story = receivedStories[indexPath.row]
                
                var profileImage: UIImage!
                
                let senderId = story["senderId"] as! String
                for friend in allFriendsInfo{
                    if friend.uid == senderId {
                        profileImage = friend.image
                    }
                }
                
                let senderName = story["senderName"] as! String
                let sendTime = story["sendTime"] as! String
                let visibleTime = story["visibleTime"] as! String
                
                let storyInfo = StoryInfo(uid: senderId, firstName: senderName, sendTime: sendTime, visibleTime: visibleTime)
                cell.updateCell(info: storyInfo, profileImage: profileImage)
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCell")
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0{
            return "Subsription"
        } else if section == 1 {
            return "Friend Stories"
        }
        else{
           return "Live"
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
        if indexPath.section != 2{
           return 70.0
        } else{
            return 310.0
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if subscriptionSet.count == 0{
                return 1
            }
            return subscriptionSet.count
            
        } else if section == 1{
            if receivedStories.count == 0{
                return 1
            }
            return receivedStories.count
        } else {
            return 1
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
        //For suggestion part
        if let destination = segue.destination as? WebVC{
            if let index = sender as? Int {
                destination.selectedUrl = webdiscover[index].url
            }
            if let name = sender as? String{
                // for live
                if name == "live"{
                    let liveUrl = "https://www.youtube.com/watch?v=wRx0S9NMl1Y"
                    destination.selectedUrl = liveUrl
                // for subscription
                } else {
                    var channelUrl: String!
                    for channel in storyChannel{
                        if channel.type == name{
                            channelUrl = channel.url
                            break
                        }
                    }
                    destination.selectedUrl = channelUrl
                }
            }
        }
        
        if let destination = segue.destination as? PresentImageVC{
            if let info = sender as? Dictionary<String, Any>{
                destination.items = info
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
