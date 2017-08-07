//
//  MasterViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 07/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var shirts = [Shirt]()


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
        
        DataManager.getShirtsWithSuccess(success: { (data) -> Void in
            var json: Any
            do {
                json = try JSONSerialization.jsonObject(with: data)
            } catch {
                print(error)
                return
            }
            
            guard let items = json as? [Any] else {
                print("Error: json data is not an array")
                return
            }
            
            Shirt.shirts(json: items, completion: { (shirts, error) in
                self.shirts = shirts
                
                if error != nil {
                    print("Parsing error: \(error!)")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })

        }, error: { (error) -> Void in
            print(error)
        })
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let shirt = shirts[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = shirt
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shirts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let shirt = shirts[indexPath.row]
        cell.textLabel!.text = shirt.description
        return cell
    }

}

