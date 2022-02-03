//
//  ShopController.swift
//  DYME!
//
//  Created by max on 15.07.2021.
//

import Foundation
import UIKit
import CoreData

class ShopController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coinLabel: UILabel!
    
    let addItemController = AddItemController()
    var shopItems : [ShopItem] = []
    var items : [CoinManager] = []
    var name: String = ""
    var explanation: String = ""
    var price: Int64 = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        let shopItem = ShopItem(context: context)
//        shopItem.name = "Wine"
//        shopItem.explanation = "Maks will buy you a bottle of nice wine"
//        shopItem.price = 1000
        //saveContext()
        NotificationCenter.default.addObserver(self, selector: #selector(coinsAdded), name: Notification.Name("coinsAdded"), object: nil)
//        NotificationCenter.default.removeObserver(self)
        fetchItems()
        coinLabel.text = String(Items.sharedInstance.coins)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddItem" {
            let addItemController = segue.destination as! AddItemController
            addItemController.delegate = self
        } else if segue.identifier == "goToBuyItem" {
            let buyItemVC = segue.destination as! BuyItemController
            buyItemVC.delegate = self
            buyItemVC.priceLabelText = price
            buyItemVC.prizeDescriptionText = explanation
            buyItemVC.prizeLabelText = name
        }
    }
    
    @IBAction func addShopItemPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAddItem", sender: self)
    }
    
    @objc func coinsAdded() {
        fetchCoinManagers()
        coinLabel.text = String(items[0].coins)
    }
}

//MARK: -TableViewDataSource

extension ShopController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = shopItems[indexPath.row].name
        return cell
    }
}



//MARK: -TableViewDelegate

extension ShopController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        name = shopItems[indexPath.row].name ?? "No name provided"
        explanation = shopItems[indexPath.row].explanation ?? "No explanation provided"
        price = shopItems[indexPath.row].price
        performSegue(withIdentifier: "goToBuyItem", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let itemToRemove = self.shopItems[indexPath.row]
            self.context.delete(itemToRemove)
            self.saveContext()
            self.fetchItems()
            self.tableView.reloadData()
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

//MARK: -TableView core data

extension ShopController {
    func fetchItems() {
        do{
            self.shopItems = try context.fetch(ShopItem.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func printShopItems() {
        for item in shopItems {
            print(item)
            print("\n")
        }
    }
    
    func clearMemory() {
        
        for item in shopItems {
            context.delete(item)
        }
        
        saveContext()
        printShopItems()
    }
    
}


//Updating coins after user bought an item
extension ShopController: BuyItemControllerDelegate {
    func updateCoinLabel() {
        Items.sharedInstance.coins -= Items.sharedInstance.coinsToWithdraw
        if (Items.sharedInstance.coinsToWithdraw <= 500) {
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {timer in
                if Items.sharedInstance.coinsToWithdraw > 0 {
                    Items.sharedInstance.coinsToWithdraw -= 1
                    self.coinLabel.text = String(Items.sharedInstance.coins + Items.sharedInstance.coinsToWithdraw)
                } else {
                    timer.invalidate()
                }
            })
        } else {
            Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: {timer in
                if Items.sharedInstance.coinsToWithdraw > 0 {
                    Items.sharedInstance.coinsToWithdraw -= 1
                    self.coinLabel.text = String(Items.sharedInstance.coins + Items.sharedInstance.coinsToWithdraw)
                } else {
                    timer.invalidate()
                }
            })
        }

        
        fetchCoinManagers()
        items[0].coins = Items.sharedInstance.coins
        saveContext()
        NotificationCenter.default.post(name: Notification.Name("coinsWithdrawn"), object: nil)
        print(items)
    }
    
    func fetchCoinManagers() {
        do{
            self.items = try context.fetch(CoinManager.fetchRequest())
        } catch {
            print(error)
        }
    }
}

extension ShopController: AddItemDelegate {
    func refreshTable() {
        fetchItems()
        tableView.reloadData()
    }
}
