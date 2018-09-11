//
//  TagsViewController.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class TagsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    let viewModel = TagViewModel()

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchTags { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.tableView.reloadData()
                case .error(let error):
                    print(error) //TODO
                }
            }
        }
    }
    
    // MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productsSegue", let selectedTag = viewModel.selectedTag, let viewController = segue.destination as? ProductsViewController {
            viewController.selectedTag(selectedTag, products: viewModel.products)
        }
    }
}

// MARK: - UITableViewDelegate
extension TagsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedTag(index: indexPath.row)
        performSegue(withIdentifier: "productsSegue", sender: self)
    }
}

// MARK: - UITableViewDataSource
extension TagsViewController: UITableViewDataSource {
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
