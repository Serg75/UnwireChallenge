//
//  FiltersDataSource.swift
//  Shirt Store
//
//  Created by Sergey S. on 08/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit


/// This class gives the data for filtering items.
class FiltersDataSource: NSObject, UITableViewDataSource {
    
    
    /// Section for filtering.
    ///
    /// - size:   Filtering by size.
    /// - colour: Filtering by colour.
    enum Section: Int {
        case size, colour
    }
    
    // MARK: - UITableViewDataSource protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == Section.size.rawValue ? "Size" : "Colour"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.size.rawValue:
            return ShirtsList.sizes.count
        default:
            return ShirtsList.colours.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch indexPath.section {
        case Section.size.rawValue:
            let size = ShirtsList.sizes[indexPath.row]
            cell.textLabel?.text = size.string
        default:
            let colour = ShirtsList.colours[indexPath.row]
            cell.textLabel?.text = colour
        }
        cell.accessoryType = isFilterSelected(indexPath.row, in: indexPath.section) ? .checkmark : .none

        return cell
    }

    
    // MARK: -
    
    private func isFilterSelected(_ filterIdx: Int, in section: Int) -> Bool {
        switch section {
        case Section.size.rawValue:
            return ShirtsList.filterSizes.contains(ShirtsList.sizes[filterIdx])
        default:
            return ShirtsList.filterColours.contains(ShirtsList.colours[filterIdx])
        }
    }
    
    
    /// This function adds size/color fo filtering.
    ///
    /// - Parameters:
    ///   - filterIdx:  Index of specified size/color in the filter.
    ///   - section:    Section for filtering (size/color).
    func selectFilter(_ filterIdx: Int, in section: Int) {
        switch section {
        case Section.size.rawValue:
            ShirtsList.filterSizes.insert(ShirtsList.sizes[filterIdx])
        default:
            ShirtsList.filterColours.insert(ShirtsList.colours[filterIdx])
        }
    }

    
    /// This function removes size/color from filtering.
    ///
    /// - Parameters:
    ///   - filterIdx:  Index of specified size/color in the filter.
    ///   - section:    Section for filtering (size/color).
    func deselectFilter(_ filterIdx: Int, in section: Int) {
        switch section {
        case Section.size.rawValue:
            ShirtsList.filterSizes.remove(ShirtsList.sizes[filterIdx])
        default:
            ShirtsList.filterColours.remove(ShirtsList.colours[filterIdx])
        }
    }
    
    
    /// This function removes all sizes and colors from filtering.
    func clearAllFilters() {
        ShirtsList.filterSizes.removeAll()
        ShirtsList.filterColours.removeAll()
    }
}
