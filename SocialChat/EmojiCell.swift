//
//  EmojiCell.swift
//  Photo Optimizer
//
//  Created by 黄 康平 on 10/15/16.
//  Copyright © 2016 黄 康平. All rights reserved.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    @IBOutlet weak var Emoji: UIImageView!
    
func configureCell(id:Int){
    
    Emoji.image = UIImage(named: "emoji\(id).jpg")
    
}

}
