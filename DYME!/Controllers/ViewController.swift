//
//  ViewController.swift
//  DYME!
//
//  Created by max on 11.07.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timerField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var motivationLabel: UILabel!
    
    let shapeLayer = CAShapeLayer()
    var stopTimer = false
    var time = ""
    var minutes : Int64 = 0
    var seconds : Int64 = 0
    var secondsWhenLocked : Int64 = 0
    var minutesWhenLocked : Int64 = 0
    var stopChangingQuotes: Bool = false
    
    
    var items : [CoinManager] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var statsDate : [StatsDate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isHidden = true
        stopButton.isUserInteractionEnabled = false
        makeCircle()
        
        self.view.bringSubviewToFront(timerField)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
        NotificationCenter.default.addObserver(self, selector: #selector(coinsWithdrawn), name: Notification.Name("coinsWithdrawn"), object: nil)
        saveContext()
        fetchCoinManagers()
//        FIRSTLAUNCH
//        let coinManager = CoinManager(context: context)
//        coinManager.coins = 0
//        fetchCoinManagers()
//        saveContext()
//____________________________
        Items.sharedInstance.coins = items[0].coins
        coinLabel.text = String(items[0].coins)
//        items[0].coins = 10000
//        saveContext()
        
        //stats and date
        

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
//        FIRSTLAUNCH
//        let date = StatsDate(context: context)
//        date.prevDate = dateFormatter.string(from: Date())
//        saveContext()
//_______________________________________
        fetchDate()
        let currentDate = dateFormatter.string(from: Date())
        if currentDate == statsDate[0].prevDate {
            
        } else {
            statsDate[0].prevDate = dateFormatter.string(from: Date())
            saveContext()
            Items.sharedInstance.updateTimeSpent = true
//          create new entry in Results array
        }
        
//        let date = StatsDate(context: context)
        
//        date.prevDate = dateFormatter.string(from: Date())
//        saveContext()
        let quotes = ["Поработаем?", "Что насчет поработать?", "Если сейчас поработать, то потом можно сладко отдохнуть", "Куча дел? Ничего страшного, ты справишься. Как и всегда", "Время поработать!", "Если сейчас не поработать потом будет обидно что не поработал"]
        let index = Int.random(in: 0..<quotes.count)
        motivationLabel.text = quotes[index]
    }
    
    func motivate() {
        let quotes = ["Ты все сможешь!", "Победи своего врага!", "Что насчет выключить уведомления на телефоне?)))", "Работа сама себя не сделает", "Работа не волк - в лес не убежт. А жаль(", "Работа не волк - работа ворк", "Терпенье и труд на бюджет переведут!", "Все получится!"]
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: {timer in
            let index = Int.random(in: 0..<quotes.count)
            self.motivationLabel.text = quotes[index]
            if self.stopChangingQuotes {
                timer.invalidate()
                self.stopChangingQuotes = false
            }
        })
    }
    
    
    @objc func didTapView() {
        self.view.endEditing(true)
        
        if (timerField.text == "") {
            timerField.text = "00:00"
            return
        }
        
        if (timerField.text!.contains(":")) {
            return
        }
        
        timerField.text = timerField.text! + ":00"
        
        if (timerField.text!.components(separatedBy: ":")[0] == "000" || timerField.text!.components(separatedBy: ":")[0] == "0") {
            timerField.text = "00:00"
        }
        
        if (timerField.text!.count > 6) {
            timerField.text = "hey, stop"
            return
        }
        
        //to animate purple ring back to -pi/2 position when time is up and user typed new time
        //(field.text = 0:00 when time is up)
        if (timerField.text != "0:00") {
            startTimer(reset: true)
        }
        
    }
    
    @objc func coinsWithdrawn() {
        fetchCoinManagers()
        coinLabel.text = String(items[0].coins)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        if (timerField.text == "00:00" || timerField.text == "0:00") {
            return
        }
        
        stopTimer = false
        
        statsButton.isUserInteractionEnabled = false
        timerField.isUserInteractionEnabled = false
        changeButtons()
        
        time = timerField.text!.components(separatedBy: ":")[0]
        Items.sharedInstance.timeGained = Int(time)!
        
        
        if (time == timerField.text) {
            return
        }
        
        startTimer(reset: false)
        
        self.tabBarController?.tabBar.isHidden = true
        motivate()
    }
    
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Your coins will be lost", message: "If you stop the timer you will lose your coins", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            self.timerField.isUserInteractionEnabled = true
            self.statsButton.isUserInteractionEnabled = true
            
            self.stopTimer = true
            self.changeButtons()
            
            self.view.bringSubviewToFront(self.timerField)
            self.timerField.text = "00:00"
            self.startTimer(reset: true)
            self.tabBarController?.tabBar.isHidden = false
            self.stopChangingQuotes = true
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            print("cancel pressed")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - stats button
    @IBAction func statsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToStats", sender: self)
    }
    
    
    func changeButtons() {
        if startButton.isHidden {
            stopButton.isHidden = true
            stopButton.isUserInteractionEnabled = false
            
            startButton.isHidden = false
            startButton.isUserInteractionEnabled = true
        } else {
            startButton.isUserInteractionEnabled = false
            startButton.isHidden = true
            
            stopButton.isHidden = false
            stopButton.isUserInteractionEnabled = true
        }
    }
    
}

//MARK: -CoinManager core data

extension ViewController {
    
    func addCoins(_ n: Int64) {
        items[0].coins = items[0].coins + n
        saveContext()
        fetchCoinManagers()
        printCoinManagers()
    }
    
    func setCoins(_ n: Int64) {
        items[0].coins = n
        saveContext()
        fetchCoinManagers()
    }
    
    /*func addCoins(_ n: Int64) {
        //creating new coin manager
        let newCoinManager = CoinManager(context: context)
        newCoinManager.coins = items[0].coins + n
        saveContext()
        fetchCoinManager()
        printCoinManagers()
        
        // deleting old coin manager
        context.delete(items[0])
        saveContext()
        fetchCoinManager()
        printCoinManagers()
    }*/
    
    func fetchCoinManagers() {
        do {
            self.items = try context.fetch(CoinManager.fetchRequest())
            //print(self.items)
        } catch {
            print(error)
        }
    }
    
    func printCoinManagers() {
        for item in items {
            print(item)
            print("\n")
        }
        
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func clearMemory() {
        
        for item in items {
            context.delete(item)
        }
        
        saveContext()
        print(items)
        
    }
}


//MARK: -stats date core data
extension ViewController {
    func fetchDate() {
        do {
            self.statsDate = try context.fetch(StatsDate.fetchRequest())
            //print(self.items)
        } catch {
            print(error)
        }
    }
}
