//
//  WebVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/17/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class WebVC: UIViewController,UIWebViewDelegate {

    @IBOutlet var discoverWeb: UIWebView!
    @IBOutlet weak var barTitleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverWeb.delegate = self
        let url = URL(string: "http://www.google.com")
        let request = URLRequest(url: url!)
        discoverWeb.loadRequest(request)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let titleText = discoverWeb.stringByEvaluatingJavaScript(from: "document.title")
        print("Title is \(titleText)")
        barTitleLbl.text = titleText
    }
    

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
