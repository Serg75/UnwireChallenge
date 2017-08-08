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

    var detailViewController: DetailViewController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let updateButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(populateItems(_:)))
        self.navigationItem.rightBarButtonItem = updateButton
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func populateItems(_ sender: Any) {
        
        ShirtsList.loadShirts(success: { 
            DispatchQueue.main.async {
                self.updateShirts()
                if ShirtsList.hasShirts {
                    self.filterButton.isEnabled = true
                    self.filterIcon.alpha = 1
                }
            }
        }) {
            let alertController = UIAlertController(title: "Error", message: "Server doesn't response", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateShirts() {
        tableView.reloadData()
        let filtersCount = ShirtsList.selectedFiltersCount
        filterLabel.text = filtersCount > 0 ? "(\(filtersCount))" : ""
        itemsCountLabel.text = "\(ShirtsList.shirts.count) items"
        
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
        (cell as! ItemTableViewCell).setupSell(shirt: shirt)
        return cell
    }

}

