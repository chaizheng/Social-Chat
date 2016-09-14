//
//  MainVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
}

    
    override func viewDidAppear(_ animated: Bool) {

//        let userView = UserVC(nibName: "UserVC", bundle: nil)
//        self.addChildViewController(userView)
//        self.scrollView.addSubview(userView.view)
//        userView.didMove(toParentViewController: self)
//        
//        var userViewFrame = userView.view.frame
//        userViewFrame.origin = CGPoint(x: self.view.frame.width, y: 0)
//        userView.view.frame = userViewFrame
        
        let cameraView = storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
        addChildViewController(cameraView)
        self.scrollView.addSubview(cameraView.view)
        cameraView.didMove(toParentViewController: self)
        
        var cameraFrame : CGRect = cameraView.view.frame
        cameraFrame.origin = CGPoint(x: self.view.frame.width, y: 0)
        cameraView.view.frame = cameraFrame
        
        let storyView : StoryVC = StoryVC(nibName: "StoryVC", bundle: nil)
        self.addChildViewController(storyView)
        self.scrollView.addSubview(storyView.view)
        storyView.didMove(toParentViewController: self)
        
        var storyViewFrame : CGRect = storyView.view.frame
        storyViewFrame.origin = CGPoint(x: self.view.frame.width * 2, y: 0)
        storyView.view.frame = storyViewFrame
        
        
        let chatView : ChatVC = ChatVC(nibName: "ChatVC", bundle: nil)
        self.addChildViewController(chatView)
        self.scrollView.addSubview(chatView.view)
        chatView.didMove(toParentViewController: self)
        
        var chatViewFrame : CGRect = chatView.view.frame
        chatViewFrame.origin = CGPoint(x: 0, y: 0)
        chatView.view.frame = chatViewFrame

     
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: self.view.frame.size.height)
        

        
        self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
        
        
}
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
