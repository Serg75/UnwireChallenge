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
    private var bagList: BagList!
    
    
    /// Updates outlets by values.
    ///
    /// - Parameters:
    ///   - shirt:   'Shirt' structure with values.
    ///   - bagList: Bag list object for injection.
    ///   - isInBag: Specifies whether this item in the bag.
    ///   - shirtQuantity: Available quantity of the shirt.
    func setupSell(shirt: Shirt, bagList: BagList, isInBag: Bool = false, shirtQuantity: Int = 0) {
        
        self.item = shirt
        self.bagList = bagList
        
        nameLabel.text = shirt.name
        colourLabel.text = shirt.colour
        sizeLabel.text = "size \(shirt.size)"
        priceLabel.text = "€\(shirt.price.description)"
        quantityLabel.text = shirt.quantity.formattedQuantity(markSoldedOut: true)
        
        if let bagIcon = self.bagIcon {
            bagIcon.isHidden = !isInBag
        }
        
        if let incButton = increaseQuantityButton {
            incButton.isEnabled = shirt.quantity < shirtQuantity
        }
        if let decButton = reduceQuantityButton {
            decButton.isEnabled = shirt.quantity > 1
        }
    }
    
    func setPicture(_ image: UIImage?) {
        self.thumbView.image = image
    }

    @IBAction func increaseQuantity(_ sender: Any) {
        bagList.increaseQuantity(item: item)
    }
    
    @IBAction func reduceQuantity(_ sender: Any) {
        bagList.reduceQuantity(item: item)
    }
    
    @IBAction func removeFromBag(_ sender: Any) {
        bagList.removeFromBag(item: item)
    }
    
    
}
