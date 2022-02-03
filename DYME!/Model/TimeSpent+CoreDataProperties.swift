//
//  TimeSpent+CoreDataProperties.swift
//  DYME!
//
//  Created by max on 29.08.2021.
//
//

import Foundation
import CoreData


extension TimeSpent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeSpent> {
        return NSFetchRequest<TimeSpent>(entityName: "TimeSpent")
    }

    @NSManaged public var timeSpent: Int64

}

extension TimeSpent : Identifiable {

}
