//
//  ProductTableViewCell.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class ProductTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productInventoryLabel: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var imageLoadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadingIndicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Configurable
extension ProductTableViewCell: Configurable {
    func configure(using data: Any) {
        guard let product = data as? Product else {
            productNameLabel.text = nil
            productInventoryLabel.text = nil
            return
        }
        productNameLabel.text = product.title
        productInventoryLabel.text = "Total Inventory: " + String(product.variants.map { $0.inventory }.reduce(0, +))
        productImage.image = product.image
        
        // For the scope of this project, every product has an image. Therefore we can say that if the image in the cell is nil, we are still waiting for it to be loaded
        if productImage.image != nil {
            imageLoadingIndicator.stopAnimating()
        }
    }
}
