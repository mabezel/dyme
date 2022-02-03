//
//  StatsController.swift
//  DYME!
//
//  Created by max on 06.08.2021.
//

import Foundation
import UIKit

class StatsController: UIViewController {
    @IBOutlet weak var statsTable: UITableView!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var todayTime: UILabel!
    
    var goal: Int = 0
    var results: [Results] = []
    var timeArr: [TimeSpent] = []
    var goalArr: [TodayGoal] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        FIRSTLAUNCH
//        let todayGoal = TodayGoal(context: context)
//        todayGoal.goal = 5
//        saveContext()
//        let result = Results(context: context)
//        result.goal = 1
//        result.result = 2
//        result.resultDate = "01/02/03"
//        saveContext()
//        let timeSpent = TimeSpent(context: context)
//        timeSpent.timeSpent = 0
//        saveContext()
//___________________________________
        fetchTimeSpent()
        fetchTodayGoal()
        fetchResults()
        goalTextField.text = String(goalArr[0].goal) + "h"
        let minutes = timeArr[0].timeSpent % 60
        let hours = (timeArr[0].timeSpent - minutes) / 60
        todayTime.text = String(hours) + "h " + String(minutes) + "m"
        statsTable.delegate = self
        statsTable.dataSource = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
        if (Items.sharedInstance.updateTime) {
            changeTime()
        }
        
//        Items.sharedInstance.updateTimeSpent = true
        if Items.sharedInstance.updateTimeSpent {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            let date = dateFormatter.string(from: Date.yesterday)
            
            let result = Results(context: context)
            result.goal = goalArr[0].goal * 60
            result.result = timeArr[0].timeSpent
            result.resultDate = date
            saveContext()
            
            Items.sharedInstance.updateTimeSpent = false
            timeArr[0].timeSpent = 0
            saveContext()
            fetchResults()
            todayTime.text = "0h 0m"
        }

        
//        let result = Results(context: context)
//        result.goal = 1
//        result.result = 2
//        result.resultDate = "01/02/03"
//        saveContext()
        
        determineColor()
        reverseTable()
    }
    
    func reverseTable() {
        results.reverse()
        statsTable.reloadData()
    }
    
    func determineColor() {
        if timeArr[0].timeSpent >= goalArr[0].goal * 60 {
            todayTime.textColor = #colorLiteral(red: 0.2814052701, green: 0.4960419536, blue: 0.1473118365, alpha: 1)
        } else {
            todayTime.textColor = #colorLiteral(red: 0.594634831, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func changeTime() {
        timeArr[0].timeSpent += Int64(Items.sharedInstance.timeGained)
        saveContext()
        let minutes = timeArr[0].timeSpent % 60
        let hours = (timeArr[0].timeSpent - minutes) / 60
        todayTime.text = String(hours) + "h " + String(minutes) + "m"
        Items.sharedInstance.updateTime = false
    }
    
    @objc func didTapView() {
        self.view.endEditing(true)
        
        if goalTextField.text == "" {
            goalTextField.text = "0h"
            return
        }
        
        if (goalTextField.text!.count > 3) {
            goalTextField.text = "0h"
            return
        }
        
        if !((goalTextField.text?.contains("h"))!) {
            goalTextField.text = goalTextField.text! + "h"
        }
        goalArr[0].goal = Int64(goalTextField.text!.components(separatedBy: "h")[0])!
        saveContext()
        
        determineColor()
    }
    
    
}

extension StatsController: UITableViewDelegate {
    
}

extension StatsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath)
        
        let minutes = results[indexPath.row].result % 60
        let hours = (results[indexPath.row].result - minutes) / 60
        cell.textLabel?.text = String(hours) + "h " + String(minutes) + "m"
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 12))
        myLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        myLabel.text = results[indexPath.row].resultDate
        
        
        if results[indexPath.row].result >= results[indexPath.row].goal {
            myLabel.textColor = #colorLiteral(red: 0.2814052701, green: 0.4960419536, blue: 0.1473118365, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0.2814052701, green: 0.4960419536, blue: 0.1473118365, alpha: 1)
        } else {
            cell.textLabel?.textColor = #colorLiteral(red: 0.594634831, green: 0, blue: 0, alpha: 1)
            myLabel.textColor = #colorLiteral(red: 0.594634831, green: 0, blue: 0, alpha: 1)
        }
        cell.accessoryView = myLabel
        //cell.textLabel?.text = statsItems[indexPath.row].result
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension StatsController {

    func fetchResults() {
        do {
            self.results = try context.fetch(Results.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func fetchTimeSpent() {
        do {
            self.timeArr = try context.fetch(TimeSpent.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func fetchTodayGoal() {
        do {
            self.goalArr = try context.fetch(TodayGoal.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func clearResults() {
        for item in results {
            context.delete(item)
        }
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
