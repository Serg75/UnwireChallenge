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
    @IBOutlet weak var bagIcon: UIImageView!
    
    
    /// Updates outlets by values.
    ///
    /// - Parameters:
    ///   - shirt:   'Shirt' structure with values.
    ///   - isInBag: Specifies whether this item in the bag.
    func setupSell(shirt: Shirt, isInBag: Bool = false) {
        nameLabel.text = shirt.name
        colourLabel.text = shirt.colour
        sizeLabel.text = "size \(shirt.size)"
        priceLabel.text = "€\(shirt.price.description)"
        quantityLabel.text = shirt.quantity.formattedQuantity(markSoldedOut: true)
        
        DataManager.getImageFrom(link: shirt.picture) { image in
            self.thumbView.image = image
        }

        if let bagIcon = self.bagIcon {
            bagIcon.isHidden = !isInBag
        }
    }
}
