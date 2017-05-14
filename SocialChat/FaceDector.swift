//
//  FaceDector.swift
//  SocialChat
//
//  Created by zheng chai on 17/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class FaceDector: UIViewController {
    

    @IBOutlet var mylabel: UILabel!
    @IBOutlet var myImage: UIImageView!
    
    var newImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myImage.image = newImage
    }

    override func viewWillAppear(_ animated: Bool) {
        myImage.image = newImage
        print("willAppear")
    }
    
    func findFace(){
        //guard let faceImage = CIImage(cgImage: myImage.image)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
