//
//  AddItemController.swift
//  DYME!
//
//  Created by max on 15.07.2021.
//

import Foundation
import UIKit

protocol AddItemDelegate: AnyObject {
    func refreshTable()
}

class AddItemController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var itemDescriptionField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    weak var delegate : AddItemDelegate? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemNameField.delegate = self
        itemDescriptionField.delegate = self
        priceField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
        view.backgroundColor = .black
    }
    
    @objc func didTapView() {
        self.view.endEditing(true)
    } 
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let item = ShopItem(context: context)
        item.name = itemNameField.text
        item.explanation = itemDescriptionField.text
        item.price = Int64(priceField.text!) ?? 0
        
        context.insert(item)
        do {
            try context.save()
        } catch {
            print(error)
        }
        delegate?.refreshTable()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemNameField.borderStyle = UITextField.BorderStyle.roundedRect
        itemNameField.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
        
        itemDescriptionField.borderStyle = UITextField.BorderStyle.roundedRect
        itemDescriptionField.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
