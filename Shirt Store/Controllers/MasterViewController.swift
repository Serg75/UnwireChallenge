//
//  MasterViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, ItemsInjectionClient {

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
    
    
    // dependency injection
    
    private var provider: DataProvider!
    private var shirtsList: ShirtsList!
    private var bagList: BagList!
    
    func set(provider: DataProvider, shirtsList: ShirtsList, bagList: BagList) {
        self.provider = provider
        self.shirtsList = shirtsList
        self.bagList = bagList
    }

    
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
        
        shirtsList.loadShirts(success: {

            self.bagList.restoreItemsWithShirts(self.shirtsList.shirts)
            
            DispatchQueue.main.async {
                self.updateShirts()
                if self.shirtsList.hasShirts {
                    self.filterButton.isEnabled = true
                    self.filterIcon.alpha = 1
                    self.updateBag()
                }
            }
        }, fail: { _ in
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
        })
    }
    
    func updateShirts() {
        tableView.reloadData()
        let filtersCount = shirtsList.selectedFiltersCount
        filterLabel.text = filtersCount > 0 ? "(\(filtersCount))" : ""
        itemsCountLabel.text = "\(shirtsList.shirts.count) lots"
    }
    
    func updateBag() {
        let bagItemsCount = bagList.itemsCount
        bagItemsCountLabel.text = bagItemsCount > 0 ? "\(bagItemsCount)" : ""
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let shirt = shirtsList.shirts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = shirt
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
        if let target = segue.destination as? ItemsInjectionClient {
            target.set(provider: self.provider, shirtsList: self.shirtsList, bagList: self.bagList)
        } else if let target = (segue.destination as? UINavigationController)?.topViewController as? ItemsInjectionClient {
            target.set(provider: self.provider, shirtsList: self.shirtsList, bagList: self.bagList)
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
        return shirtsList.shirts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let shirt = shirtsList.shirts[indexPath.row]
        let inBag = bagList.isItemInBag(shirt)
        (cell as! ItemTableViewCell).setupSell(shirt: shirt, bagList: bagList, isInBag: inBag)

        provider.loadImageFrom(link: shirt.picture) { (image) in
            (cell as! ItemTableViewCell).setPicture(image)
        }

        return cell
    }

}

