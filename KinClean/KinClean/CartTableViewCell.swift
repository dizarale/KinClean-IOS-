//
//  CartTableViewCell.swift
//  KinClean
//
//  Created by user on 4/22/16.
//  Copyright © 2016 inknock. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var menu_name: UILabel!
   
    @IBOutlet weak var menu_cost: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
