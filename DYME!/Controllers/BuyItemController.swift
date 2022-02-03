//
//  BuyItemController.swift
//  DYME!
//
//  Created by max on 16.07.2021.
//

import Foundation
import UIKit

protocol BuyItemControllerDelegate: AnyObject {
    func updateCoinLabel()
}

class BuyItemController: UIViewController {
    
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var prizeDescriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    weak var delegate: BuyItemControllerDelegate? = nil
    
    var prizeLabelText = ""
    var prizeDescriptionText = ""
    var priceLabelText : Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        prizeLabel.text = prizeLabelText
        prizeDescriptionLabel.text = prizeDescriptionText
        priceLabel.text = "Price: " + String(priceLabelText) + " dymes"
    }
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        if priceLabelText <= Items.sharedInstance.coins {
            Items.sharedInstance.coinsToWithdraw = priceLabelText
            delegate?.updateCoinLabel()
            Items.sharedInstance.purchaseDate = Date()
            Items.sharedInstance.purchaseName = prizeLabel.text ?? ":( no name"
            NotificationCenter.default.post(name: NSNotification.Name("productBought"), object: nil)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Not enough coins", message: "Save some more money and come back later :)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

