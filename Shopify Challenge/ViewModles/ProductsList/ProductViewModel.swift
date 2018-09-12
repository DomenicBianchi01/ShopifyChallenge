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
    private var products: [Product] = []
    private var productsFiltered: Bool = false
    private var tag: String = ""
    private let imageService = ProductImageService()
    
    // MARK: - Helper Functions
    /**
     Set the starting array of products (all the products) and the tag that will be used to filter the products
     
     - parameter products: Unfiltered array of products
     - parameter tag: The tag that will be used to filter the products
     */
    func setStartingProductsAndSearchTag(products: [Product], tag: String) {
        self.products = products
        self.tag = tag
    }

    /**
      Filter products based on the `tag`. This function will also fetch the images for each filtered product if the image has not yet been retrieved

     - parameter tag: The tag to filter the products by. If nil, the tag property belonging to this class is used.
     - parameter completion: If successful, returns `Void` within the success enum case (see Result.swift), otherwise an `Error`
    */
    func filterProducts(on tag: String? = nil, with completion: @escaping ((Result<Void>) -> Void)) {
        let searchTag: String
        
        if let unwrappedTag = tag {
            searchTag = unwrappedTag
        } else {
            searchTag = self.tag
        }
        
        self.products = products.filter { $0.tags.contains(searchTag) }
        
        productsFiltered = true
        
        // Move to the background otherwise the dispatch group will block the current thread
        DispatchQueue.global(qos: .background).async {
            let dispatchGroup = DispatchGroup()
            for product in self.products {
                // Only fetch the image if we haven't yet fetched the image once (prevents making additional network requests when we already have the image)
                if product.image == nil {
                    dispatchGroup.enter()
                    self.fetchImage(from: product.imageSource) { result in
                        switch result {
                        case .success(let image):
                            product.image = image
                            dispatchGroup.leave()
                        case .error:
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
            dispatchGroup.wait()
            completion(.success(()))
        }
    }
    
    /**
     Fetch an image from the provided URL
     
     - parameter url: The URL containing the image
     - parameter completion: If successful, returns a `UIImage`, otherwise an `Error`
    */
    private func fetchImage(from url: URL, with completion: @escaping ((Result<UIImage>) -> Void)) {
        imageService.fetchImage(from: url) { result in
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
        return productsFiltered ? products.count : 0
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productReuseIdentifier", for: indexPath)
        
        if let configurableCell = cell as? Configurable, indexPath.row < products.count {
            configurableCell.configure(using: products[indexPath.row])
        }
        
        return cell
    }
    
}
