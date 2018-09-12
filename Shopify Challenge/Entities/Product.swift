//
//  Product.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

class Product: Decodable {
    // MARK: - Properties
    let title: String
    let tags: [String]
    let variants: [Variant]
    let imageSource: URL
    /// This property is not populated until it is needed to prevent making unnecessary network requests.
    var image: UIImage?
    
    // MARK: - Lifecycle Functions
    init(title: String,
         tags: [String],
         variants: [Variant],
         imageSource: URL,
         image: UIImage? = nil) {

        self.title = title
        self.tags = tags
        self.variants = variants
        self.imageSource = imageSource
        self.image = image
    }
    
    // MARK: - Decodable
    private enum ProductKeys: String, CodingKey {
        case title
        case tags
        case variants
        case image
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let tags = try container.decode(String.self, forKey: .tags)
        let variants = try container.decode([Variant].self, forKey: .variants)
        let image = try container.decode(Image.self, forKey: .image)

        let tagsArray = tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces)}
        
        self.init(title: title,
                  tags: tagsArray,
                  variants: variants,
                  imageSource: image.source)
    }
}
