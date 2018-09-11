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
    func setStartingProducts(products: [Product]) {
        self.products = products
    }

    func filter(_ products: [Product], on tag: String, with completion: @escaping ((Result<Void>) -> Void)) {
        self.products = products.filter { $0.tags.contains(tag) }
        
        let downloadGroup = DispatchGroup()
        
        for product in self.products {
            downloadGroup.enter()
            fetchImage(from: product.imageSource) { result in
                switch result {
                case .success(let image):
                    product.image = image
                    downloadGroup.leave()
                case .error:
                    downloadGroup.leave()
                }
            }
        }
        
        downloadGroup.wait()
        completion(.success(()))
    }
    
    private func fetchImage(from url: URL, with completion: @escaping ((Result<UIImage>) -> Void)) {
        ImageService().fetchImage(from: url) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .error(let error):
                completion(.error(error))
            }
        }
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
