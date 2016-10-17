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
    var faceExpress = "the faces are"
    override func viewDidLoad() {
        super.viewDidLoad()


        myImage.image = newImage
//        myImage.image = #imageLiteral(resourceName: "face")
       findFace()
    }

    func findFace(){
//        guard let faceImage = CIImage(cgImage: newImage!.cgImage!) else{return}
        let faceImage = CIImage(cgImage: (newImage?.cgImage)!)
        //let faceImage = CIImage(cgImage: #imageLiteral(resourceName: "face").cgImage!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
       // let faces = faceDetector?.features(in: faceImage)
        let faces = faceDetector?.features(in: faceImage, options: [CIDetectorSmile: true, CIDetectorEyeBlink: true])
        for face in faces as! [CIFaceFeature]{
            if face.hasSmile{
                label.text = faceExpress.appending(" smile ")
            }
            
            if face.leftEyeClosed{
                label.text = faceExpress.appending(" left eyes closed")
            }
            
            if face.rightEyeClosed{
                label.text = faceExpress.appending(" right eyes closed")
            }
        }
        
        if faces?.count == 0{
            label.text = "no faces"
        }
        
    }
}
