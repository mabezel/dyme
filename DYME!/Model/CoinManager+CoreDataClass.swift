//
//  CoinManager+CoreDataClass.swift
//  DYME!
//
//  Created by max on 13.07.2021.
//
//

import Foundation
import CoreData

@objc(CoinManager)
public class CoinManager: NSManagedObject {
    
    func setCoins() {
        coins = 1
    }
    
    func getCoins() -> Int64 {
        return coins
    }
    
    func addCoins(_ num: Int64) {
        coins += num
    }
}
