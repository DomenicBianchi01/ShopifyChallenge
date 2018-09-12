//
//  UIViewControllerExtensions.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-11.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Display a basic alert on the screen. Only an "OK" alert action will be included.
     
     - parameter title: The title of the alert
     - parameter message: The message to be displayed on the alert
     */
    func displayAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
