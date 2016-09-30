//
//  Item+CoreDataClass.swift
//  
//
//  Created by zheng chai on 30/09/2016.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
