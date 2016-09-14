//
//  MainVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var scrollViewHor: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.disableScroll), name: NSNotification.Name(rawValue: "Disable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.enableScroll), name: NSNotification.Name(rawValue: "Enable"), object: nil)
    }
    
    func enableScroll() {
        scrollViewHor.isScrollEnabled = true
    }
    
    func disableScroll() {
        scrollViewHor.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let chatView = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.addChildViewController(chatView)
        self.scrollViewHor.addSubview(chatView.view)
        chatView.didMove(toParentViewController: self)
        
//        var chatViewFrame : CGRect = chatView.view.frame
//        chatViewFrame.origin = CGPoint(x: 0, y: 0)
//        chatView.view.frame = chatViewFrame
//        

        let verticalView = storyboard?.instantiateViewController(withIdentifier: "VerticalVC") as! VerticalVC
        addChildViewController(verticalView)
        self.scrollViewHor.addSubview(verticalView.view)
        verticalView.didMove(toParentViewController: self)
        
        var verticalFrame : CGRect = verticalView.view.frame
        verticalFrame.origin = CGPoint(x: self.view.frame.width, y: 0)
        verticalView.view.frame = verticalFrame
        
        
        let storyView = storyboard?.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
        self.addChildViewController(storyView)
        self.scrollViewHor.addSubview(storyView.view)
        storyView.didMove(toParentViewController: self)
        
        var storyViewFrame : CGRect = storyView.view.frame
        storyViewFrame.origin = CGPoint(x: self.view.frame.width * 2, y: 0)
        storyView.view.frame = storyViewFrame
        
        let discoverView = storyboard?.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
        self.addChildViewController(discoverView)
        self.scrollViewHor.addSubview(discoverView.view)
        discoverView.didMove(toParentViewController: self)
        
        var discoverViewFrame : CGRect = discoverView.view.frame
        discoverViewFrame.origin = CGPoint(x: self.view.frame.width * 3, y: 0)
        discoverView.view.frame = discoverViewFrame
        

        
        
        
        
        scrollViewHor.contentSize = CGSize(width: self.view.frame.size.width * 4, height: self.view.frame.size.height)
        self.scrollViewHor.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        
        
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
