//
//  DetailViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, ItemsInjectionClient {
    
    private var isItemInBag = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToBagButton: UIButton!

    
    // dependency injection
    
    private var provider: DataProvider!
    private var bagList: BagList!
    
    func set(provider: DataProvider, shirtsList: ShirtsList, bagList: BagList) {
        self.provider = provider
        self.bagList = bagList
    }
    

    func configureView() {
        // Update the user interface for the detail item.
        if let item = self.detailItem {
            if let label = self.nameLabel { label.text = item.name }
            if let label = self.colourLabel { label.text = item.colour }
            if let label = self.sizeLabel { label.text = "size \(item.size)" }
            if let label = self.priceLabel { label.text = "€\(item.price.description)" }
            if let label = self.quantityLabel { label.text = item.quantity.formattedQuantity(markSoldedOut: true) }
            
            if (self.imageView) != nil {
                provider.loadImageFrom(link: item.picture, completion: { image in
                    self.imageView.image = image
                })
            }
            
            if let button = self.addToBagButton, item.quantity < 1 {
                button.isHidden = true
            }
        } else {
            if let label = self.nameLabel { label.text = "" }
            if let label = self.colourLabel { label.text = "" }
            if let label = self.sizeLabel { label.text = "" }
            if let label = self.priceLabel { label.text = "" }
            if let label = self.quantityLabel { label.text = "" }
            if let button = self.addToBagButton { button.isHidden = true }
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
        if let item = self.detailItem {
            isItemInBag = bagList.isItemInBag(item)
            if !isItemInBag {
                addToBagButton.setTitle("Add to Bag", for: UIControlState.normal)
            } else {
                addToBagButton.setTitle("Remove from Bag", for: UIControlState.normal)
            }
        }
    }
    
    @IBAction func addToBag(_ sender: Any) {
        if var item = self.detailItem {
            if !isItemInBag {
                // We add item with quantity = 1
                item.quantity = 1
                bagList.addToBag(item: item)
            } else {
                bagList.removeFromBag(item: item)
            }
            configureAddToBagButton()
        }
    }
}

