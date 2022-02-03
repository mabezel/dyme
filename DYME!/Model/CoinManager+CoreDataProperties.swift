//
//  CoinManager+CoreDataProperties.swift
//  DYME!
//
//  Created by max on 13.07.2021.
//
//

import Foundation
import CoreData


extension CoinManager {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinManager> {
        return NSFetchRequest<CoinManager>(entityName: "CoinManager")
    }

    @NSManaged public var coins: Int64

}

extension CoinManager : Identifiable {

}
