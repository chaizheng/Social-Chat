//
//  DiscoverCell.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/17/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class DiscoverCell: UICollectionViewCell {
    @IBOutlet weak var webImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
      //  layer.cornerRadius = 5.0
    }
    
    func configureCell(id: Int){
        titleLbl.text = "Sport"
        /*
        if let url = URL(string: "http://img1.gtimg.com/17/1756/175638/17563899_980x1200_0.jpg"){
            if let data = NSData(contentsOf: url){
                webImage.image = UIImage(data: data as Data)
            }
        }
 */
        webImage.image = UIImage(named: "testWebImage")
        typeLbl.text = "Sport"
    }
}
