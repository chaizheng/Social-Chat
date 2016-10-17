//
//  Util.swift
//  SocialChat
//
//  Created by ZhangJeff on 09/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

var webdiscover = [Webdiscover]()
var storyChannel = [Webdiscover]()

open class Util{
    
    class func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPhone(testStr: String) -> Bool {
        
        let phoneRegex = "\\d{10}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: testStr)
    }
    
    class func getCurrentTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd 'at' HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    class func parseWebsiteCSV(){
        //Discover VC
        let path1 = Bundle.main.path(forResource: "website", ofType: "csv")!
        do{
            let csv = try CSV.init(contentsOfURL: path1)
            let rows = csv.rows
            
            for row in rows{
                let type = row["Type"]
                let title = row["Title"]
                let url = row["Url"]
                
                let web = Webdiscover(url: url!, type: type!, title: title!)
                webdiscover.append(web)
            }
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
        //StoryVC Channel
        let path2 = Bundle.main.path(forResource: "channel", ofType: "csv")!
        do{
            let csv = try CSV.init(contentsOfURL: path2)
            let rows = csv.rows
            
            for row in rows{
                let channel = row["Channel"]
                let url = row["Url"]
                
                let story = Webdiscover(url: url!, type: channel!)
                storyChannel.append(story)
            }
            
        } catch let err as NSError{
            print(err.debugDescription)
        }

        
    }
    
    class func rotateImage(image:UIImage)->UIImage
    {
        var rotatedImage = UIImage();
        switch image.imageOrientation
        {
        case UIImageOrientation.right:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:UIImageOrientation.right);
            
        case UIImageOrientation.down:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:UIImageOrientation.right);
            
        case UIImageOrientation.left:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:UIImageOrientation.right);
            
        default:
            rotatedImage = UIImage(cgImage:image.cgImage!, scale: 1, orientation:UIImageOrientation.right);
        }
        return rotatedImage;
    }
    
}
