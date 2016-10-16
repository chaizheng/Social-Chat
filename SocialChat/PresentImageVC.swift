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
    
    private var counter = 0
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
