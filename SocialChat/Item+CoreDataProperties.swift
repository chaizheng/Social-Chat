//
//  Item+CoreDataProperties.swift
//  
//
//  Created by zheng chai on 30/09/2016.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var image: NSData?

}
