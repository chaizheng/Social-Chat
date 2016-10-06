//
//  User.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/18/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

struct User {
    private var _firstName: String
    private var _uid: String
    
    var uid: String{
        return _uid
    }
    
    var firstName: String{
        return _firstName
    }
    
    init(uid: String, firstName: String){
        _uid = uid
        _firstName = firstName
    }
    
    func equal(user: User) -> Bool{
        if  self.uid == user.uid{
            
            return true
        }else{
            return false
        }
    }
}
