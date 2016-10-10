//
//  AddFriendsVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 08/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class AddFriendsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    @IBAction func backItemPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
   
}
