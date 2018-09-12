//
//  ImageService.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class ProductImageService {

    // MARK: - Functions
    /**
     Similar to `JSONService` except this service will return a `UIImage`. Note that this class only supports one network request at a time unless this function is being called with the use of `DispatchGroups` (see `ProductViewModel.swift`)
     
     - parameter url: The URL of the image
     - parameter completion: If successful, returns a `UIImage`, otherwise an `Error`
    */
    func fetchImage(from url: URL, with completion: @escaping ((Result<UIImage>) -> Void)) {
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        
        let urlSession = URLSession.self
        
        let urlDataTask = urlSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                completion(.error(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCodeIsError {
                completion(.error(NSError(domain: "Could not fetch image", code: response.statusCode, userInfo: nil)))
                return
            }
    
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.error(NSError(domain: "Could not fetch image", code: 0, userInfo: nil)))
            }
        }
        urlDataTask.resume()
    }
}
