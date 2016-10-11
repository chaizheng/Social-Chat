//
//  StoryCollectionCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 11/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class StoryCollectionCell: UICollectionViewCell {
    @IBOutlet weak var webImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        //  layer.cornerRadius = 5.0
    }
    
    
    func configureCell(web:Webdiscover, id:Int){
        
        titleLbl.text = web.title
        webImage.image = UIImage(named: "\(id).jpg")
        typeLbl.text = web.type
        webImage.layer.cornerRadius = 4
        webImage.clipsToBounds = true
    }

}
