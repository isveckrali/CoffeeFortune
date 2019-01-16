//
//  ReadOrderDetailTableViewCell.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 16.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit

class ReadOrderDetailTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var detailText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
