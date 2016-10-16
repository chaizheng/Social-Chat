//
//  PresentImageVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 16/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class PresentImageVC: UIViewController {
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var items:Dictionary<String, Any>!
    var timeLeft: String!
    
    private var counter = 0
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLeft = items["visibleTime"] as? String
        timeLeftLabel.text = timeLeft
        var storyImage = items["storyImage"] as? UIImage
        storyImage = Util.rotateImage(image: storyImage!)
        imageView.image = storyImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer(){
        counter += 1
        let leftTime = Int(timeLeft)! - counter
        timeLeftLabel.text = String(leftTime)
        
        if timeLeftLabel.text == String(0){
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
