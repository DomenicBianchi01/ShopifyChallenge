//
//  Result.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

//https://www.sitepoint.com/improve-swift-closures-result/
/** A generic enum to use when returning values or errors from completion blocks.
 
 If nothing needs to be returned, set `T` to be `Void`.
 */
enum Result<T> {
    case success(T)
    case error(Error)
}
