//
//  BagItemsDataSource.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

/// The source data for the table with items from the bag
class BagItemsDataSource: NSObject, UITableViewDataSource {

    // MARK: - UITableViewDataSource protocol

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BagItems.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let shirt = BagItems.items[indexPath.row]
        (cell as! ItemTableViewCell).setupSell(shirt: shirt)
        return cell
    }

}
