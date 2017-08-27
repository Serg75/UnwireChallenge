//
//  BagItemsDataSource.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit

/// The source data for the table with items from the bag
class BagItemsDataSource: NSObject, UITableViewDataSource, ItemsInjectionClient {
    
    // dependency injection

    private var provider: DataProvider!
    private var shirtsList: ShirtsList!
    private var bagList: BagList!
    
    func set(provider: DataProvider, shirtsList: ShirtsList, bagList: BagList) {
        self.provider = provider
        self.shirtsList = shirtsList
        self.bagList = bagList
    }


    // MARK: - UITableViewDataSource protocol

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bagList.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let shirt = bagList.items[indexPath.row]
        (cell as! ItemTableViewCell).setupSell(shirt: shirt, bagList: bagList, shirtQuantity: shirtsList.quantityForShirt(shirt))
        
        provider.loadImageFrom(link: shirt.picture) { (image) in
            (cell as! ItemTableViewCell).setPicture(image)
        }

        return cell
    }

}
