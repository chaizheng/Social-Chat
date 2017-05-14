//
//  Webdiscover.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/19/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import Foundation

struct Webdiscover {
    private let _url:String
    private let _type:String
    private var _title:String? = nil
    
    init(url:String, type:String, title:String) {
        _url = url
        _type = type
        _title = title
    }
    
    init(url:String, type:String) {
        _url = url
        _type = type
    }
    
    var url:String {
        return _url
    }
    var type:String {
        return _type
    }
    var title:String? {
        return _title
    }
}

