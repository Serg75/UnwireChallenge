//
//  BagItemsViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class BagItemsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemsInfoLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    let tableViewDataSource = BagItemsDataSource()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = tableViewDataSource
        configureView()
        
        NotificationCenter.default.addObserver(forName: bagItemsNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
            
            if notification.object == nil {
                // update cell deleting with animation
                self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
            } else {
                // update quantity changing without animation
                self.tableView.reloadData()
            }
            self.configureView()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    


    // MARK: -
    
    @IBAction func clearItems() {
        BagItems.clear()
        self.tableView.reloadData()
        configureView()
    }
    
    private func configureView() {
        let itemsCount = BagItems.itemsCount
        var string = itemsCount.formattedQuantity()
        if itemsCount > 0 {
            string += ", €\(BagItems.itemsPrice)"
        }
        itemsInfoLabel.text = string
        self.proceedButton.isHidden = itemsCount == 0
        self.tableView.isHidden = itemsCount == 0
        self.clearButton.isHidden = itemsCount == 0
    }
    
    @IBAction func proceed(_ sender: Any) {
        
        guard ReachabilityManager.shared.isNetworkAvailable else {
            let alertController = UIAlertController(title: "No Internet Connection",
                                                    message: "An internet connection is required.",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok",
                                         style: UIAlertActionStyle.default,
                                         handler: nil)
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

            return
        }
        
        DataManager.sendOrder(items: BagItems.items, totalPrice: BagItems.itemsPrice, success: {

            let alertController = UIAlertController(title: "Success!",
                                                    message: "Thank you for choosing our store!",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.default,
                                         handler: { _ in
                BagItems.clear()
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindFromBagSegue", sender: self)
                }
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true)

        }) { error in
            
            let alertController = UIAlertController(title: "Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
