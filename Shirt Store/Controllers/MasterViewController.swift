//
//  MasterViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    enum SortSelection: Int {
        case size
        case colour
    }

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterIcon: UIImageView!
    @IBOutlet weak var itemsCountLabel: UILabel!

    @IBOutlet weak var bagItemsCountLabel: UILabel!

    var detailViewController: DetailViewController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            
            // Show master and details view controllers side-by-side for iPad
            if UIDevice.current.userInterfaceIdiom == .pad {
                split.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
            }
        }
        
        populateItems()
        updateBag()
        
        NotificationCenter.default.addObserver(forName: bagItemsNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
                 
            self.tableView.reloadData()
            self.updateBag()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func populateItems() {
        
        ShirtsList.loadShirts(success: { 
            DispatchQueue.main.async {
                self.updateShirts()
                if ShirtsList.hasShirts {
                    self.filterButton.isEnabled = true
                    self.filterIcon.alpha = 1
                    self.updateBag()
                }
            }
        }) {
            let alertController = UIAlertController(title: "Error", message: "Server doesn't response", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Repeat",
                                         style: UIAlertActionStyle.default,
                                         handler: { _ in
                
                    self.perform(#selector(MasterViewController.populateItems),
                                 with: nil,
                                 afterDelay: TimeInterval(1))
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateShirts() {
        tableView.reloadData()
        let filtersCount = ShirtsList.selectedFiltersCount
        filterLabel.text = filtersCount > 0 ? "(\(filtersCount))" : ""
        itemsCountLabel.text = "\(ShirtsList.shirts.count) lots"
    }
    
    func updateBag() {
        let bagItemsCount = BagItems.itemsCount
        bagItemsCountLabel.text = bagItemsCount > 0 ? "\(bagItemsCount)" : ""
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let shirt = ShirtsList.shirts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = shirt
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue) {
        updateShirts()
        updateBag()
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShirtsList.shirts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let shirt = ShirtsList.shirts[indexPath.row]
        let inBag = BagItems.isItemInBag(shirt)
        (cell as! ItemTableViewCell).setupSell(shirt: shirt, isInBag: inBag)
        return cell
    }

}

