//
//  StoryVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

var subscriptionList: [String]?

class StoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var goToDisBtn: UIButton!
    @IBOutlet weak var backToCameraBtn: UIButton!
    @IBOutlet weak var storyCollectionView: UICollectionView!
    @IBOutlet weak var storyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        storyTableView.delegate = self
        storyTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell") as! SubscriptionCell
            //cell.updateCell(friend: friend)
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableCell") as! StoryTableCell
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
            return 2
//            if let list = subscriptionList{
//                return list.count
//            } else{
//                return 0
//            }
        } else{
            // not finished story receive
            return 3
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
