//
//  AddByUsernameVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 08/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class AddByUsernameVC: UIViewController {

    @IBOutlet weak var usernameInput: RoundTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = DEFAULT_BLUE
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchBtnPressed(_ sender: AnyObject) {
    }

}
