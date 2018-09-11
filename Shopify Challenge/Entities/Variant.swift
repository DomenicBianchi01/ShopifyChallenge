//
//  Variant.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

class Variant: Decodable {
    // MARK: - Properties
    let inventory: Int
    
    // MARK: - Lifecycle Functions
    init(inventory: Int) {
        self.inventory = inventory
    }
    
    // MARK: - Decodable
    private enum VariantKeys: String, CodingKey {
        case inventory = "inventory_quantity"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: VariantKeys.self)
        let inventory = try container.decode(Int.self, forKey: .inventory)
        
        self.init(inventory: inventory)
    }
}
