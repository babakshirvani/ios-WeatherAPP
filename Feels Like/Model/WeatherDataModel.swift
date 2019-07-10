//
//  WeatherDataModel.swift
//  Feels Like
//
//  Created by Babak Shirvani on 2019-01-23.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit

class WeatherDataModel: UIViewController {
    
    //Model variables :
    
    var temperature : String = ""
    var feelsLike : String = ""
    var condition : Int = 0
    var iconCondition : String = ""
    var forecastCondition : Int = 0
    var city : String = ""
    var weatherIconName : String = ""
    var weatherCondition : String = ""
    var currentDate : String = ""
    var weekday : String = ""
    var humidity : Int = 0
    var pressure : Int = 0
    var windSpeed : String = ""
    var visibility : String = ""
    var windDirection : String = ""
    var precipitation : String = ""
    var sunrise : String = ""
    var sunset : String = ""
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
        case 1000 :
            if iconCondition == "1" {
                return "sunny"
            }
            else  {
                return "moon"
            }
        case 1003 :
            if iconCondition == "1" {
                return "sunnyAndCloudy"
            }
            else  {
                return "moonAndCloud"
            }
        case 1006,1009,1030,1135,1147 :
            return "cloud"
        case 1063 :
            if iconCondition == "1" {
                return "sunAndRaining"
            }
            else  {
                return "MoonCloudRain"
            }
        case 1066,1069,1072,1085,1114,1117,1210,1213,1216,1219,1222,1225,1237,1255,1258,1261,1279,1282 :
            return "snow"
        case 1087 :
            if iconCondition == "1" {
                return "sunAndCloudAndLight"
            }
            else  {
                return "CloudAndLight"
            }
        case 1150,1153,1168,1171,1180,1183,1186,1189,1192,1195,1198,1201,1207,1240,1243,1246,1249,1252,1264,1273,1276 :
            return "raining"
        default :
            return "sunnyAndCloudy"
        }
    }
    
}
