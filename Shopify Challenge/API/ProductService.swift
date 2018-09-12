//
//  ProductService.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class ProductService: JSONService {
    // MARK: - Functions
    /**
     Fetch a list of all the products
     
     - parameter completion: If successful, returns an array of `Product`'s, otherwise an `Error`
    */
    func fetchProducts(with completion: @escaping ((Result<[Product]>) -> Void)) {
        request(from: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6", expecting: Products.self) { result in
            switch result {
            case .success(let products):
                completion(.success(products.products))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
