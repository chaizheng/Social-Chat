//
//  FriendInfo.swift
//  SocialChat
//
//  Created by ZhangJeff on 10/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import Foundation
import UIKit

struct FriendInfo {
    
    private var _fullName: String
    private var _firstName: String
    private var _uid: String
    private var _image: UIImage
    private var _phoneNumber: String?
    
    var uid: String{
        return _uid
    }
    
    var phoneNumber: String?{
        if _phoneNumber != nil{
            return _phoneNumber!
        } else {
            print("phoneNumber is nil\n")
            return nil
        }
    }
    
    var fullName: String{
        return _fullName
    }
    
    var firstName: String{
        return _firstName
    }
    
    var image: UIImage{
        return _image
    }
    
    init(uid: String, fullName: String, firstName: String, image: UIImage, phoneNumber: String? = nil){
        _uid = uid
        _fullName = fullName
        _image = image
        _firstName = firstName
        if phoneNumber != nil{
           _phoneNumber = phoneNumber!
        }
        
    }
}
