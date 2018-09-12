//
//  TableViewModelable.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

/// View Models should implement this protocol if they will be used to populate a `TableView`
protocol TableViewModelable {
    /// The number of sections the `TableView` should have
    var numberOfSections: Int { get }
    
    /**
     The number of rows in the given section of the `TableView`
     
     - parameter section: The section number
    */
    func numberOfRows(in section: Int) -> Int
    
    /**
     Get the cell for the given index path in the `TableView`
     
     - parameter tableView: A reference to the table view that the cell belongs in
     - parameter indexPath: The location of the cell within the `tableView`
    */
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}
