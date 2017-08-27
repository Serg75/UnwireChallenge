//
//  BagItemsViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class BagItemsViewController: UIViewController, ItemsInjectionClient {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemsInfoLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    
    // dependency injection
    
    private var provider: DataProvider!
    private var shirtsList: ShirtsList!
    private var bagList: BagList!
    
    var tableViewDataSource = BagItemsDataSource()
    
    
    func set(provider: DataProvider, shirtsList: ShirtsList, bagList: BagList) {
        self.provider = provider
        self.shirtsList = shirtsList
        self.bagList = bagList
        
        tableViewDataSource.set(provider: provider, shirtsList: shirtsList, bagList: bagList)
    }
    
    
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
        bagList.clear()
        self.tableView.reloadData()
        configureView()
    }
    
    private func configureView() {
        let itemsCount = bagList.itemsCount
        var string = itemsCount.formattedQuantity()
        if itemsCount > 0 {
            string += ", €\(bagList.itemsPrice)"
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
        
        let orderData = Shirt.orderData(items: bagList.items, totalPrice: bagList.itemsPrice)
        
        provider.sendOrder(orderData: orderData) { error in
            if error == nil {
                let alertController = UIAlertController(title: "Success!",
                                                        message: "Thank you for choosing our store!",
                                                        preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: UIAlertActionStyle.default,
                                             handler: { _ in
                    self.bagList.clear()
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "unwindFromBagSegue", sender: self)
                    }
                })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
                
            } else {
                
                let alertController = UIAlertController(title: "Error",
                                                        message: error!.localizedDescription,
                                                        preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
