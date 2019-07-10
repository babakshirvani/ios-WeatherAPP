//
//  CityNameTableViewCell.swift
//  FeelsLike
//
//  Created by Babak Shirvani on 2019-02-15.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit

class CityNameTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
