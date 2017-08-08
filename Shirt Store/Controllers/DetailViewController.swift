//
//  DetailViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var isItemInBag = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToBagButton: UIButton!


    func configureView() {
        // Update the user interface for the detail item.
        if let shirt = self.detailItem {
            if let label = self.nameLabel { label.text = shirt.name }
            if let label = self.colourLabel { label.text = shirt.colour }
            if let label = self.sizeLabel { label.text = "size \(shirt.size)" }
            if let label = self.priceLabel { label.text = "€\(shirt.price.description)" }
            if let label = self.quantityLabel { label.text = shirt.quantity.formattedQuantity(markSoldedOut: true) }
            
            if (self.imageView) != nil {
                DataManager.getImageFrom(link: shirt.picture) { image in
                    self.imageView.image = image
                }
            }
            
            if let button = self.addToBagButton, shirt.quantity < 1 {
                button.isHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.configureAddToBagButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Shirt? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    private func configureAddToBagButton() {
        isItemInBag = BagItems.isItemInBag(detailItem!)
        if !isItemInBag {
            addToBagButton.setTitle("Add to Bag", for: UIControlState.normal)
        } else {
            addToBagButton.setTitle("Remove from Bag", for: UIControlState.normal)
        }
    }
    
    @IBAction func addToBag(_ sender: Any) {
        if !isItemInBag {
            BagItems.addToBag(item: detailItem!)
        } else {
            BagItems.removeFromBag(item: detailItem!)
        }
        configureAddToBagButton()
    }
}

