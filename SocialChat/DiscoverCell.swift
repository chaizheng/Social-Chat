//
//  DiscoverCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/17/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class DiscoverCell: UICollectionViewCell {
    @IBOutlet weak var holdingView: UIView!
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
    }
}
