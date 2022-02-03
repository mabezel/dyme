//
//  Results+CoreDataProperties.swift
//  DYME!
//
//  Created by max on 25.08.2021.
//
//

import Foundation
import CoreData


extension Results {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Results> {
        return NSFetchRequest<Results>(entityName: "Results")
    }

    @NSManaged public var resultDate: String?
    @NSManaged public var result: Int64
    @NSManaged public var goal: Int64

}

extension Results : Identifiable {

}
