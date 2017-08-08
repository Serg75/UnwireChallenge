//
//  FiltersViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showResultButton: UIButton!
    
    let tableViewDataSource = FiltersDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = tableViewDataSource
        
        updateShowResultButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - UITableViewDelegate protocol

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                tableViewDataSource.deselectFilter(indexPath.row, in: indexPath.section)
            }
            else{
                cell.accessoryType = .checkmark
                tableViewDataSource.selectFilter(indexPath.row, in: indexPath.section)
            }
            updateShowResultButton()
        }
    }
    
    
    // MARK: -
    
    @IBAction func clearSelection(_ sender: Any) {
        tableViewDataSource.clearAllFilters()
        tableView.reloadData()
        updateShowResultButton()
    }
    
    private func updateShowResultButton() {
        showResultButton.setTitle("Show \(ShirtsList.shirts.count) items", for: UIControlState.normal)
    }
}
