//
//  ProductsViewController.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class ProductsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let viewModel = ProductViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        // It is not possible for this function to return a error. If an image for a product couldn't be fetched, that is not considered an error since there may be other product images that can be fetched
        viewModel.filterProducts { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Helper Functions
    /**
     Set the tag that was selected and the list of unfiltered products. This function is called after a tag is selected in the `TagsViewController`
     
     - parameter tag: The selected tag
     - parameter products: Unfiltered array of products
    */
    func tagSelected(_ tag: String, products: [Product]) {
        viewModel.setStartingProductsAndSearchTag(products: products, tag: tag)
        self.title = tag
    }
}

// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* Not used */ }
}

// MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(in: tableView, at: indexPath)
    }
}
