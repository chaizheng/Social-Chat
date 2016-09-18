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
    
    @IBOutlet weak var backBtn: UIButton!
    
    private var _selectedUrl: Int!
    
    var selectedUrl: Int{
        get{
            return _selectedUrl
        }
        set{
            _selectedUrl = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverWeb.delegate = self
        let url:URL!
        if _selectedUrl == 1 {
            url = URL(string: "http://www.google.com")
        } else {
            url = URL(string: "http://www.qq.com")
        }
        let request = URLRequest(url: url)
        discoverWeb.loadRequest(request)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let titleText = discoverWeb.stringByEvaluatingJavaScript(from: "document.title")
        barTitleLbl.text = titleText
    }
    

    @IBAction func backBtnPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
