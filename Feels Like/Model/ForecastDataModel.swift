//
//  ForecastDataModel.swift
//  FeelsLike
//
//  Created by Babak Shirvani on 2019-02-04.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import Foundation
import SwiftyJSON


class ForecastDataModel {
    
    var forecastDate: String = ""
    var forecastDay: String = ""
    var forecastIconId: String = ""
    var forecastMinTemp : String = ""
    var forecastMaxTemp : String = ""
    
    
    init(weatherDict: Dictionary<String, AnyObject>){
        if let TempResult = weatherDict["day"] as? Dictionary<String, AnyObject> {
            if let minTempResult = TempResult["mintemp_c"] as? Double {
                let minTemp = String( Int(Double(minTempResult).rounded()))
                self.forecastMinTemp = minTemp
            }
            if let maxTempResult = TempResult["maxtemp_c"] as? Double {
                let maxTemp = String(Int(Double(maxTempResult).rounded()))
                self.forecastMaxTemp = maxTemp
            }
        }
        if let date = weatherDict["date_epoch"] as? Double {
            let rawDate = Date(timeIntervalSince1970: date)
            let dayFormatter = DateFormatter()
            dayFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dayFormatter.dateFormat = "EEEE"
            self.forecastDay = dayFormatter.string(from: rawDate)
            let forecastDateFormatter = DateFormatter()
            forecastDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            forecastDateFormatter.dateStyle = .medium
            forecastDateFormatter.timeStyle = .none
            self.forecastDate = forecastDateFormatter.string(from: rawDate)
        }
        if let forecastConditionDay = weatherDict["day"] as? Dictionary<String, AnyObject> {
            if let forecastCondition = forecastConditionDay["condition"] as? Dictionary<String, AnyObject> {
                if let iconId = forecastCondition["code"] as? Int {
                    self.forecastIconId = updateForecastIcon(condition: iconId)
                }
            }
        }
    }
    
    func updateForecastIcon(condition: Int) -> String {
        
        switch (condition) {
        case 1000 :
            return "sunny"
        case 1003 :
            return "sunnyAndCloudy"
        case 1006,1009,1030,1135,1147 :
            return "cloud"
        case 1063 :
            return "sunAndRaining"
        case 1066,1069,1072,1085,1114,1117,1210,1213,1216,1219,1222,1225,1237,1255,1258,1261,1279,1282 :
            return "snow"
        case 1087 :
            return "sunAndCloudAndLight"
        case 1150,1153,1168,1171,1180,1183,1186,1189,1192,1195,1198,1201,1207,1240,1243,1246,1249,1252,1264,1273,1276 :
            return "raining"
        default :
            return "sunnyAndCloudy"
        }
    }
}
