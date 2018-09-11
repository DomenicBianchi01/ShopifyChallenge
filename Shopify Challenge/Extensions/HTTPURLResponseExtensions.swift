//
//  HTTPURLResponseExtensions.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    /// Returns true if the status code is between 400 and 599 (inclusive)
    var statusCodeIsError: Bool {
        switch self.statusCode {
        case 400..<600:
            return true
        default:
            return false
        }
    }
}
