//
//  ToDoController.swift
//  DYME!
//
//  Created by max on 15.07.2021.
//

import Foundation
import UIKit

class ShoppingCartController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cartItems : [CartItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchItems()
//        clearMemo()
//        fetchItems()
//        saveContext()
        fetchItems()
        table.reloadData()
        table.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: Notification.Name("productBought"), object: nil)
        reverseTable()
    }
    
    func reverseTable() {
        cartItems.reverse()
        table.reloadData()
    }
//    @objc func updateTable() {
//        let cartItem = CartItem(context: context)
//        cartItem.itemDate = Items.sharedInstance.purchaseDate
//        cartItem.itemName = Items.sharedInstance.purchaseName
//        cartItem.isSelected = false
//        cartItems.append(cartItem)
//        fetchItems()
//        saveContext()
//        table.reloadData()
//    }
    
    @objc func updateTable() {
        let cartItem = CartItem(context: context)
        cartItem.itemDate = Items.sharedInstance.purchaseDate
        cartItem.itemName = Items.sharedInstance.purchaseName
        cartItem.isSelected = false
        saveContext()
        fetchItems()
        reverseTable()
        table.reloadData()
    }
    
    //MARK: -Core data
    func fetchItems() {
        do{
            self.cartItems = try context.fetch(CartItem.fetchRequest())
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
    
    func clearMemo() {
        for item in cartItems {
            context.delete(item)
        }
        saveContext()
    }
    
}

extension ShoppingCartController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cartItems[indexPath.row].isSelected {
            cartItems[indexPath.row].isSelected = false
        } else {
            cartItems[indexPath.row].isSelected = true
        }
        saveContext()
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (cartItems.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            let date = dateFormatter.string(from: cartItems[indexPath.row].itemDate!)
            cell.configure(with: date)
            if cartItems[indexPath.row].isSelected {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cartItems[indexPath.row].itemName ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                //cell.textLabel?.text = (cell.textLabel?.text ?? "") + " V"
                cell.textLabel?.attributedText = attributeString
            } else {
                cell.textLabel?.attributedText = NSAttributedString(string: "")
                cell.textLabel?.text = cartItems[indexPath.row].itemName
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
