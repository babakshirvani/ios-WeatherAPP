//
//  ForecastCell.swift
//  FeelsLike
//
//  Created by Babak Shirvani on 2019-02-02.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit


class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var nextDaysLabel: UILabel!
    @IBOutlet weak var nextDaysIcon: UIImageView!
    @IBOutlet weak var nextDaysMinTemp: UILabel!
    @IBOutlet weak var nextDaysMaxTemp: UILabel!
    @IBOutlet weak var nextDaysDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureForecastCell(forecastData: ForecastDataModel) {
        self.nextDaysMinTemp.text = forecastData.forecastMinTemp
        self.nextDaysMaxTemp.text = forecastData.forecastMaxTemp
        self.nextDaysLabel.text = String(forecastData.forecastDay)
        self.nextDaysDateLabel.text = String("  " + forecastData.forecastDate)
        self.nextDaysIcon.image = UIImage(named: forecastData.forecastIconId)
    }
    
}
