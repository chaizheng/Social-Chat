//
//  DiscoverVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/14/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit


class DiscoverVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {

    @IBOutlet weak var backToStory: UIButton!
  
    @IBOutlet weak var discoverCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discoverCollection.dataSource = self
        discoverCollection.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        discoverCollection.collectionViewLayout = layout
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(discoverCollection.contentOffset)
//    }
//    //useless when animated is false
//    override func viewDidAppear(_ animated: Bool) {
//        discoverCollection.setContentOffset(CGPoint(x:0,y:800), animated: false)
//    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCell", for: indexPath) as? DiscoverCell{
            
            cell.configureCell(id:indexPath.row + 1)
            return cell
            
        } else{
            return UICollectionViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebVC{
            if let index = sender as? Int {
                destination.selectedUrl = index
            }
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showwebview", sender: indexPath.row)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        //Original size of cell
        let width = (self.view.frame.width / 3 ) - 1
        let height = self.view.frame.height / 3
        
        switch indexPath.row {
        case 0,8,20,28,41:
            return CGSize(width: width * 3 + 3, height: height)
        case 4,7,13,15,21,24,30,31,38,39,43,44,47:
            return CGSize(width:width * 2 + 2, height: height)
        case 12,33:
            return CGSize(width:width * 3 + 3, height: height*2)
        default:
            return CGSize(width: width, height: height)
        }
        
    }
    
    
    @IBAction func backToStoryBtnPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goLeft"), object: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
