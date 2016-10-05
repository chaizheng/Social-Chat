//
//  MainVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

protocol MainScrollVCDelegate {
    func verScrollEnable() -> Bool
}

//avoid apear again
var firstTimeAppear = true

let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
let userStoryboard = UIStoryboard.init(name: "User", bundle: nil)
let editStoryboard = UIStoryboard.init(name: "Edit", bundle: nil)

class MainVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollViewHor: UIScrollView!
    var delegate:MainScrollVCDelegate?
    var initialContenOffset = CGPoint()
    var firstTimeSettingOffset = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewHor.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.goLeft), name: NSNotification.Name(rawValue: "goLeft"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.goRight), name: NSNotification.Name(rawValue: "goRight"), object: nil)
    }
    
    //Swipe left
    func goLeft() {
        UIView.animate(withDuration: 0.2) {
            self.scrollViewHor.contentOffset.x -= self.view.frame.width
        }
    }
    //Swipe Right
    func goRight() {
        UIView.animate(withDuration: 0.2) {
            self.scrollViewHor.contentOffset.x += self.view.frame.width
        }
    }
    
    // Horizontal scrolling disabled in top and bottom
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        initialContenOffset = scrollViewHor.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (delegate != nil && delegate?.verScrollEnable() == false && firstTimeSettingOffset != true){
            scrollViewHor.setContentOffset(initialContenOffset, animated: false)
        }
    }
    
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        if firstTimeAppear{
        let chatView = userStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.addChildViewController(chatView)
        self.scrollViewHor.addSubview(chatView.view)
        chatView.didMove(toParentViewController: self)

        let verticalView = mainStoryboard.instantiateViewController(withIdentifier: "VerticalVC") as! VerticalVC
        addChildViewController(verticalView)
        self.scrollViewHor.addSubview(verticalView.view)
        verticalView.didMove(toParentViewController: self)
        
        var verticalFrame : CGRect = verticalView.view.frame
        verticalFrame.origin = CGPoint(x: self.view.frame.width, y: 0)
        verticalView.view.frame = verticalFrame
        
        let storyView = mainStoryboard.instantiateViewController(withIdentifier: "StoryVC") as! StoryVC
        self.addChildViewController(storyView)
        self.scrollViewHor.addSubview(storyView.view)
        storyView.didMove(toParentViewController: self)
        
        var storyViewFrame : CGRect = storyView.view.frame
        storyViewFrame.origin = CGPoint(x: self.view.frame.width * 2, y: 0)
        storyView.view.frame = storyViewFrame
        
        let discoverView = mainStoryboard.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
        self.addChildViewController(discoverView)
        self.scrollViewHor.addSubview(discoverView.view)
        discoverView.didMove(toParentViewController: self)
        
        var discoverViewFrame : CGRect = discoverView.view.frame
        discoverViewFrame.origin = CGPoint(x: self.view.frame.width * 3, y: 0)
        discoverView.view.frame = discoverViewFrame
        
        delegate = verticalView
        
        scrollViewHor.contentSize = CGSize(width: self.view.frame.size.width * 4, height: self.view.frame.size.height)
        self.scrollViewHor.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
        firstTimeSettingOffset = false
        firstTimeAppear = false
        }
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
