//
//  SenderInfo.swift
//  SocialChat
//
//  Created by ZhangJeff on 09/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import Foundation

struct SenderInfo {
    private var _fullName: String
    private var _uid: String
    private var _sendTime: String
    private var _imageUrl: String
    private var _username: String
    
    var uid: String{
        return _uid
    }
    
    var fullName: String{
        return _fullName
    }
    
    var sendTime: String{
        return _sendTime
    }
    
    var imageUrl: String{
        return _imageUrl
    }
    
    var username: String{
        return _username
    }
    
    init(uid: String, fullName: String, sendTime: String, imageUrl: String, username: String){
        _uid = uid
        _fullName = fullName
        _username = username
        _imageUrl = imageUrl
        _sendTime = sendTime
    }
}
