//
//  Timer.swift
//  DYME!
//
//  Created by max on 11.07.2021.
//

import UIKit

extension ViewController {
    func makeCircle() {
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 150, startAngle: (-CGFloat.pi) / 2, endAngle: 2*CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
//      круг
        trackLayer.strokeColor = #colorLiteral(red: 0.2666666667, green: 0.2705882353, blue: 0.2705882353, alpha: 1).cgColor
        trackLayer.lineWidth = 10
        
        shapeLayer.path = circularPath.cgPath
//        линия
        shapeLayer.strokeColor = #colorLiteral(red: 0.8980392157, green: 0.5490196078, blue: 0.5411764706, alpha: 1).cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
//        бэкграунд
        shapeLayer.fillColor = #colorLiteral(red: 0.9519228339, green: 0.8526319861, blue: 0.6202811003, alpha: 1).cgColor
        
        
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)
        
    }
    
    func startTimer(reset: Bool) {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        if reset == false {
            basicAnimation.toValue = 1
            basicAnimation.duration = ((Double(time) ?? 0) * 60) + ((Double(time) ?? 0) * 14)
            if (basicAnimation.duration == 0) {
                return
            }
            minutes = Int64(time)!
            changeTime(minutes)
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
        } else {
            basicAnimation.speed = 0.3
            basicAnimation.duration = 0
        }
        shapeLayer.add(basicAnimation, forKey: "randomString")
    }
    
    func changeTime(_ minutes: Int64) {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {timer in
//            if UIApplication.shared.applicationState == .background {
//                let currentDate = Date()
//            }
            
            //if sceneWillEnterForeground was called and in user locked phone
            //PROBLEM: timer will fire anyway before sceneWillEnterForeground is called so 1 second may be lost everytime user locks & unlocks their phone
            //TODO: distinguish between locked phone and exited application
            if Items.sharedInstance.phoneWasLocked {
                self.secondsWhenLocked = self.seconds
                self.minutesWhenLocked = self.minutes
                Items.sharedInstance.phoneWasLocked = false
            }
         
            if Items.sharedInstance.sceneWillEnterCalled && Items.sharedInstance.counter > 1 {
                let time = round(Items.sharedInstance.timeAccumulated) // V
                let minutesSinceLocked = Int(floor(time / 60))
                let secondsSinceLocked = Int(Int(time) - minutesSinceLocked * 60)
                self.seconds = self.secondsWhenLocked // V
                //self.minutes = self.minutesWhenLocked
                
                if self.seconds < Int64(secondsSinceLocked) {
                    self.seconds = Int64(secondsSinceLocked) - self.seconds
                    self.seconds = 60 - self.seconds
                    self.minutes = self.minutes - 1 - Int64(minutesSinceLocked) //???
                } else {
                    self.seconds = self.seconds - Int64(secondsSinceLocked)
                    self.minutes = self.minutes - Int64(minutesSinceLocked)
                }
                
                if self.minutes < 0 {
                    self.seconds = 0
                    self.minutes = 0
                }

//                if (self.minutesWhenLocked * 60 + self.secondsWhenLocked)
//                        > (Int64(minutesSinceLocked *  60) + Int64(secondsSinceLocked)) {
//                    //print(Int64(secondsSinceLocked))
//                    print(time)
//                    print(Int64(minutesSinceLocked))
//                    print(Int64(secondsSinceLocked))
//                    print(self.seconds)
//
//                    if self.seconds < Int64(secondsSinceLocked) {
//                        self.seconds = Int64(secondsSinceLocked) - self.seconds
//                        self.minutes = self.minutes - Int64(minutesSinceLocked)
//                    } else {
//                        self.seconds = self.seconds - Int64(secondsSinceLocked)
//                        self.minutes = self.minutes - Int64(minutesSinceLocked)
//                    }
//                    self.updateTimeField()
//                } else {
//                    self.seconds = 0
//                    self.minutes = 0
//                }
                self.updateTimeField()
                Items.sharedInstance.sceneWillEnterCalled = false
            }
            
            if self.stopTimer == false {
                if self.seconds > 0 {
                    self.seconds = self.seconds - 1
                } else if self.minutes > 0 && self.seconds == 0 {
                    self.minutes = self.minutes - 1
                    self.seconds = 59
                } else if self.minutes == 0 && self.seconds == 0 {
                    self.addCoins(minutes)
                    self.coinLabel.text = String(self.items[0].coins)
                    Items.sharedInstance.coins = self.items[0].coins
                    //self.coinManager.addCoins(minutes)
                    //self.coinLabel.text = String(self.coinManager.getCoins())
                    self.changeButtons()
                    self.timerField.isUserInteractionEnabled = true
                    self.statsButton.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name("coinsAdded"), object: nil)
                     Items.sharedInstance.updateTime = true
                    self.tabBarController?.tabBar.isHidden = false
                    timer.invalidate()
                    self.stopChangingQuotes = true
                }
                self.updateTimeField()
            } else {
                self.seconds = 0
                self.minutes = 0
                timer.invalidate()
            }
            
        })
    }
    
    func updateTimeField() {
        if (seconds < 10) {
            timerField.text = String(minutes) + ":0" + String(seconds)
            return
        }
        timerField.text = String(minutes) + ":" + String(seconds)
    }
}
