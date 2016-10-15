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
    private var _profileUrl: String
    private var _storyUrl: String
    
    var uid: String{
        return _uid
    }
    
    var firstName: String{
        return _firstName
    }
    
    var sendTime: String{
        return _sendTime
    }
    
    var profileUrl: String{
        return _profileUrl
    }
    
    var storyUrl: String{
        return _storyUrl
    }
    
    init(uid: String, fullName: String, sendTime: String, profileUrl: String, storyUrl: String){
        _uid = uid
        _firstName = fullName
        _storyUrl = storyUrl
        _profileUrl = profileUrl
        _sendTime = sendTime
    }
}
