//
//  Image.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

class Image: Decodable {
    // MARK: - Properties
    let source: URL
    
    // MARK: - Lifecycle Functions
    init(source: URL) {
        self.source = source
    }
    
    // MARK: - Decodable
    private enum ImageKeys: String, CodingKey {
        case source = "src"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImageKeys.self)
        let source = try container.decode(String.self, forKey: .source)
        
        guard let imageSource = URL(string: source) else {
                throw DecodingError.typeMismatch(URL.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Could not decode image url"))
        }
        
        self.init(source: imageSource)
    }
}
