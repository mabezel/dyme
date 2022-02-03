//
//  StatsDate+CoreDataProperties.swift
//  DYME!
//
//  Created by max on 25.08.2021.
//
//

import Foundation
import CoreData


extension StatsDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatsDate> {
        return NSFetchRequest<StatsDate>(entityName: "StatsDate")
    }

    @NSManaged public var prevDate: String?

}

extension StatsDate : Identifiable {

}
