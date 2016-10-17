//
//  FaceDetect.swift
//  SocialChat
//
//  Created by zheng chai on 17/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class FaceDetect: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var myImage: UIImageView!
    
    var newImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myImage.image = newImage
    }

    func findFace(){
//        guard let faceImage = CIImage(cgImage: newImage!.cgImage!) else{return}
        let faceImage = CIImage(cgImage: (newImage?.cgImage)!)
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: faceImage)
        for face in faces as! [CIFaceFeature]{
            if face.hasSmile{
                
            }
        }
        
    }
}
