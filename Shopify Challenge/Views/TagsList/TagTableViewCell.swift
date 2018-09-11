//
//  TagTableViewCell.swift
//  Shopify Challenge
//
//  Created by Domenic Bianchi on 2018-09-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class TagTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet var tagLabel: UILabel!
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Configurable
extension TagTableViewCell: Configurable {
    func configure(using data: Any) {
        guard let tag = data as? String else {
            tagLabel.text = nil
            return
        }
        tagLabel.text = tag
    }
}
