//
//  ShopItem+CoreDataProperties.swift
//  DYME!
//
//  Created by max on 15.07.2021.
//
//

import Foundation
import CoreData


extension ShopItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopItem> {
        return NSFetchRequest<ShopItem>(entityName: "ShopItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Int64
    @NSManaged public var explanation: String?

}

extension ShopItem : Identifiable {

}
