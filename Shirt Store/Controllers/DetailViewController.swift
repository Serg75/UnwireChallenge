//
//  DetailViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

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
            if let label = self.quantityLabel { label.text = shirt.quantity.formattedQuantity }
            
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

    
    @IBAction func addToBag(_ sender: Any) {
    }
}

