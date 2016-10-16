//
//  StoryInfo.swift
//  SocialChat
//
//  Created by ZhangJeff on 15/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import Foundation

struct StoryInfo {
    
    private var _firstName: String
    private var _uid: String
    private var _sendTime: String
    private var _visibleTime: Int
    
    var uid: String{
        return _uid
    }
    
    var firstName: String{
        return _firstName
    }
    
    var sendTime: String{
        return _sendTime
    }
    
    
    var visibleTime: Int{
        return _visibleTime
    }
    
    
    init(uid: String, firstName: String, sendTime: String, visibleTime: Int){
        _uid = uid
        _firstName = firstName
        _sendTime = sendTime
        _visibleTime = visibleTime
    }
}
