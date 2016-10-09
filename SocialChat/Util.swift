//
//  Util.swift
//  SocialChat
//
//  Created by ZhangJeff on 09/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import Foundation

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
    
}
