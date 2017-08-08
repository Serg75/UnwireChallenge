//
//  ItemTableViewCell.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    func setupSell(shirt: Shirt) {
        nameLabel.text = shirt.name
        colourLabel.text = shirt.colour
        sizeLabel.text = "size \(shirt.size)"
        priceLabel.text = "€\(shirt.price.description)"
        quantityLabel.text = shirt.quantity.formattedQuantity
        
        DataManager.getImageFrom(link: shirt.picture) { image in
            self.thumbView.image = image
        }
    }
}
