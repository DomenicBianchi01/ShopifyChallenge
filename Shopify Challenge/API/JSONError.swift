//
//  JSONError.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

/// A class that can be used to decode a JSON response containing only an error
class JSONError: Decodable {
    var errors: String
}
