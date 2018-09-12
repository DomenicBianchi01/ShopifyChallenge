//
//  TagViewModel.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class TagViewModel {
    // MARK: - Properties
    private var tags: [String] = []
    private(set) var selectedTag: String? = nil
    private(set) var products: [Product] = []
    
    // MARK: - Helper Functions
    /**
     Get a list of all the types of tags from the server
     
     - parameter completion: If successful, returns `Void` within the success enum case (see Result.swift), otherwise an `Error`
     */
    func fetchTags(with completion: @escaping ((Result<Void>) -> Void)) {
        ProductService().fetchProducts { result in
            switch result {
            case .success(let products):
                self.tags = self.getUniqueTags(from: products)
                self.products = products
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func setSelectedTag(index: Int) {
        selectedTag = tags[index]
    }
    
    /**
     Products can share tags, so filter out the duplicates such that we end with an array of unique tags
     
     - parameter products: The array of products to filter through for their tags
     - returns: An array of unique tags
    */
    private func getUniqueTags(from products: [Product]) -> [String] {
        var uniqueTags = Set<String>()
        for product in products {
            uniqueTags.formUnion(product.tags.map { $0 })
        }
        
        //There is no need to keep the data in a Set at this point so just transform it into a normal array and sort alphabetically
        return Array(uniqueTags).sorted { $0 < $1 }
    }
}

extension TagViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return tags.count
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagReuseIdentifier", for: indexPath)
        
        if let configurableCell = cell as? Configurable, indexPath.row < tags.count {
            configurableCell.configure(using: tags[indexPath.row])
        }
        
        return cell
    }

}
