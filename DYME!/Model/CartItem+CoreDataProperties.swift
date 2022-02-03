//
//  CartItem+CoreDataProperties.swift
//  DYME!
//
//  Created by max on 05.08.2021.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var isSelected: Bool
    @NSManaged public var itemDate: Date?
    @NSManaged public var itemName: String?

}

extension CartItem : Identifiable {

}
