//
//  ImageService.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class ImageService {
    func fetchImage(from url: URL, with completion: @escaping ((Result<UIImage>) -> Void)) {
        let dispatchQueue = DispatchQueue(label: "fetchImageData",
                                          qos: .userInitiated,
                                          attributes: [],
                                          autoreleaseFrequency: .inherit,
                                          target: nil)
        
        dispatchQueue.async {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    completion(.success(image))
                    return
                }
            } catch {}

            completion(.error(NSError(domain: "Could not fetch image", code: 0, userInfo: nil)))
        }
    }
}
