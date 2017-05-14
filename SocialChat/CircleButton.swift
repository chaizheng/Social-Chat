//
//  CircleButton.swift
//  SocialChat
//
//  Created by zheng chai on 15/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 30.0 {
        didSet{
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView(){
        layer.cornerRadius = cornerRadius
    }

}
