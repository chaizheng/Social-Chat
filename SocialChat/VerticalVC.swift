//
//  VerticalVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/14/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class VerticalVC: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollViewVer: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(VerticalVC.logoBtnPressed), name: NSNotification.Name(rawValue: "logoBtnPressed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VerticalVC.goMemBtnPressed), name: NSNotification.Name(rawValue: "goMemBtnPressed"), object: nil)
    }
    
    func logoBtnPressed() {
        UIView.animate(withDuration: 0.2) {
             self.scrollViewVer.contentOffset.y = 0
        }
    }
    func goMemBtnPressed() {
        UIView.animate(withDuration: 0.2) {
            self.scrollViewVer.contentOffset.y = self.view.frame.height * 2
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollViewVer.contentOffset.y == 0 || scrollViewVer.contentOffset.y == 2 * self.view.frame.size.height{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Disable"), object: nil)
            }
            if scrollViewVer.contentOffset.y == self.view.frame.size.height {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Enable"), object: nil)
            }
        }
//
    override func viewDidAppear(_ animated: Bool) {
        scrollViewVer.delegate = self
        self.scrollViewVer.translatesAutoresizingMaskIntoConstraints = true
        
        
        let userInfoView = storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
        addChildViewController(userInfoView)
        self.scrollViewVer.addSubview(userInfoView.view)
        userInfoView.didMove(toParentViewController: self)
        
        let cameraView = storyboard?.instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
        addChildViewController(cameraView)
        self.scrollViewVer.addSubview(cameraView.view)
        cameraView.didMove(toParentViewController: self)
        
        var cameraFrame : CGRect = cameraView.view.frame
        cameraFrame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
        cameraView.view.frame = cameraFrame
        
        let memoryView = storyboard?.instantiateViewController(withIdentifier: "MemoryVC") as! MemoryVC
        addChildViewController(memoryView)
        self.scrollViewVer.addSubview(memoryView.view)
        memoryView.didMove(toParentViewController: self)
        
        var memoryFrame : CGRect = memoryView.view.frame
        memoryFrame.origin = CGPoint(x: 0, y: self.view.frame.size.height * 2)
        memoryView.view.frame = memoryFrame
        
        scrollViewVer.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height * 3)
        scrollViewVer.contentOffset = CGPoint(x: 0, y: self.view.frame.size.height)
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
