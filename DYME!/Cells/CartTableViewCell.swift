//
//  CartTableViewCell.swift
//  DYME!
//
//  Created by max on 27.07.2021.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var CellDateLable: UILabel!
    static let identifier = "CartTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CartTableViewCell", bundle: nil)
    } 
    
    public func configure(with date: String) {
        CellDateLable.text = date
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
