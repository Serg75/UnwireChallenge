//
//  FiltersViewController.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate, ItemsInjectionClient {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showResultButton: UIButton!
    
    let tableViewDataSource = FiltersDataSource()

    
    // dependency injection

    var shirtsList: ShirtsList!
    
    func set(provider: DataProvider, shirtsList: ShirtsList, bagList: BagList) {
        self.shirtsList = shirtsList
        tableViewDataSource.set(provider: provider, shirtsList: shirtsList, bagList: bagList)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = tableViewDataSource
        
        showResultButton.setTitleColor(UIColor.gray, for: UIControlState.disabled)
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
        var string = ""
        switch shirtsList.shirts.count {
        case 0:
            string = "Nothign to show"
            showResultButton.isEnabled = false
        case 1:
            string = "Show 1 lot"
            showResultButton.isEnabled = true
        default:
            string = "Show \(shirtsList.shirts.count) lots"
            showResultButton.isEnabled = true
        }
        showResultButton.setTitle(string, for: UIControlState.normal)
    }
}
