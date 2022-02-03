//
//  SharedInstance.swift
//  DYME!
//
//  Created by max on 16.07.2021.
//

import Foundation

class Items {
    static var sharedInstance = Items()
    var coinsToWithdraw: Int64 = 0
    var coins: Int64 = 0
    
    var lockDate: Date = Date()
    var timeAccumulated: Double = 0
    var sceneWillEnterCalled = false
    var phoneWasLocked = false
    var counter: Int = 0
    
    var purchaseDate: Date = Date()
    var purchaseName: String = ""
    
    var timeGained: Int = 0
    var updateTime: Bool = false
    var updateTimeSpent: Bool = false
}
