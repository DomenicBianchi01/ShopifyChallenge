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
    let id: Int
    let title: String
    let body: String
    let vendor: String
    let productType: String
    let handle: String
    let dateCreated: Date
    let dateUpdated: Date
    let datePublished: Date
    let tags: [String]
    let publishedScope: String
    let variants: [Variant]
    let imageSource: URL
    /// This property is not populated until it is needed to prevent making unnecessary network requests
    var image: UIImage?
    
    // MARK: - Lifecycle Functions
    init(id: Int,
         title: String,
         body: String,
         vendor: String,
         productType: String,
         handle: String,
         dateCreated: Date,
         dateUpdated: Date,
         datePublished: Date,
         tags: [String],
         publishedScope: String,
         variants: [Variant],
         imageSource: URL,
         image: UIImage? = nil) {

        self.id = id
        self.title = title
        self.body = body
        self.vendor = vendor
        self.productType = productType
        self.handle = handle
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.datePublished = datePublished
        self.tags = tags
        self.publishedScope = publishedScope
        self.variants = variants
        self.imageSource = imageSource
        self.image = image
    }
    
    // MARK: - Decodable
    private enum ProductKeys: String, CodingKey {
        case id
        case title
        case body = "body_html"
        case vendor
        case productType = "product_type"
        case handle
        case dateCreated = "created_at"
        case dateUpdated = "updated_at"
        case datePublished = "published_at"
        case tags
        case publishedScope = "published_scope"
        case variants
        case image
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let body = try container.decode(String.self, forKey: .body)
        let vendor = try container.decode(String.self, forKey: .vendor)
        let productType = try container.decode(String.self, forKey: .productType)
        let handle = try container.decode(String.self, forKey: .handle)
        let dateCreatedString = try container.decode(String.self, forKey: .dateCreated)
        let dateUpdatedString = try container.decode(String.self, forKey: .dateUpdated)
        let datePublishedString = try container.decode(String.self, forKey: .datePublished)
        let tags = try container.decode(String.self, forKey: .tags)
        let publishedScope = try container.decode(String.self, forKey: .publishedScope)
        let variants = try container.decode([Variant].self, forKey: .variants)
        let image = try container.decode(Image.self, forKey: .image)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        guard let dateCreated = dateFormatter.date(from: dateCreatedString),
            let dateUpdated = dateFormatter.date(from: dateUpdatedString),
            let datePublished = dateFormatter.date(from: datePublishedString) else {
                throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot decode date created, date updated, and/or date published"))
        }
        
        let tagsArray = tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces)}
        
        self.init(id: id,
                  title: title,
                  body: body,
                  vendor: vendor,
                  productType: productType,
                  handle: handle,
                  dateCreated: dateCreated,
                  dateUpdated: dateUpdated,
                  datePublished: datePublished,
                  tags: tagsArray,
                  publishedScope: publishedScope,
                  variants: variants,
                  imageSource: image.source)
    }
}
