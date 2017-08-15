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
    @IBOutlet weak var increaseQuantityButton: UIButton!
    @IBOutlet weak var reduceQuantityButton: UIButton!
    
    
    private var item: Shirt!
    
    
    /// Updates outlets by values.
    ///
    /// - Parameters:
    ///   - shirt:   'Shirt' structure with values.
    ///   - isInBag: Specifies whether this item in the bag.
    func setupSell(shirt: Shirt, isInBag: Bool = false) {
        
        item = shirt
        
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
        
        if let incButton = increaseQuantityButton {
            incButton.isEnabled = shirt.quantity < ShirtsList.quantityForShirt(shirt)
        }
        if let decButton = reduceQuantityButton {
            decButton.isEnabled = shirt.quantity > 1
        }
    }

    @IBAction func increaseQuantity(_ sender: Any) {
        BagItems.increaseQuantity(item: item)
    }
    
    @IBAction func reduceQuantity(_ sender: Any) {
        BagItems.reduceQuantity(item: item)
    }
    
    @IBAction func removeFromBag(_ sender: Any) {
        BagItems.removeFromBag(item: item)
    }
    
    
}
