//
//  ProductViewModel.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class ProductViewModel {
    // MARK: - Properties
    private(set) var products: [Product] = []
    
    // MARK: - Helper Functions
    func filter(_ products: [Product], on tag: String) {
        self.products = products.filter { $0.tags.contains(tag) }
    }
}

extension ProductViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return products.count
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productReuseIdentifier", for: indexPath)
        
        if let configurableCell = cell as? Configurable, indexPath.row < products.count {
            configurableCell.configure(using: products[indexPath.row])
        }
        
        return cell
    }
    
}
