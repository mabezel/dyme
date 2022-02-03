//
//  TodayGoal+CoreDataProperties.swift
//  DYME!
//
//  Created by max on 29.08.2021.
//
//

import Foundation
import CoreData


extension TodayGoal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodayGoal> {
        return NSFetchRequest<TodayGoal>(entityName: "TodayGoal")
    }

    @NSManaged public var goal: Int64

}

extension TodayGoal : Identifiable {

}
