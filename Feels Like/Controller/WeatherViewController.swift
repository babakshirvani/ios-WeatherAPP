//
//  WeatherViewController.swift
//  FeelsLike
//
//  Created by Babak Shirvani on 2019-01-23.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class WeatherViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, ChangeCityDelegate {
    
    //constant
    
    let FORECAST_URL = "YOUR WEATHER API"
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    let forecastCell = ForecastCell()
    
    var refreshControl = UIRefreshControl()
    var forecastDataModel : ForecastDataModel!
    var forecastArray = [ForecastDataModel]()
    var passedValue = String()
    var forecastParams:String = ""
    var longitude:String = ""
    var latitude:String = ""
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLable: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.alwaysBounceVertical = true
        scrollView.bounces  = true
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: UIControl.Event.valueChanged)
        self.scrollView.addSubview(refreshControl)
        
        //location manager
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        //side menu NotificationCenter
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name("loadData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAddNewCity), name: NSNotification.Name("ShowAddNewCity"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPolicy), name: NSNotification.Name("ShowPolicy"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTermsOfUse), name: NSNotification.Name("ShowTermsOfUse"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAbout), name: NSNotification.Name("ShowAbout"), object: nil)
    }
    
    // Side menu Segue
    @objc func loadData(_ notification: Notification) {
        currentLocationButton()
    }
    @objc func showAddNewCity() {
        performSegue(withIdentifier: "changeCityName", sender: nil)
    }
    @objc func showAbout() {
        performSegue(withIdentifier: "ShowAbout", sender: nil)
    }
    @objc func showPolicy() {
        performSegue(withIdentifier: "ShowPolicy", sender: nil)
    }
    @objc func showTermsOfUse() {
        performSegue(withIdentifier: "ShowTermsOfUse", sender: nil)
    }
    
    func currentLocationButton(){
        self.navigationController?.popToRootViewController(animated: true)
        getWeatherDataForCityName(q: forecastParams)
        getForecastDataForCityName(q: forecastParams)
        updateUIWithWeatherData()
    }
    
    @IBAction func sideMenuPressed() {
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func didPullToRefresh(_ sender: Any) {
        refreshCurrentCityNameData()
        updateUIWithWeatherData()
        print("Refersh")
        
        // For End refrshing
        refreshControl.endRefreshing()
    }
    
    func refreshCurrentCityNameData() {
        if cityLabel.text != "Weather Unavailable" && cityLabel.text != "Connection Issues"{
            let cityName = cityLabel.text!
            let trimmedString = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
            let removeSpaceCityName = trimmedString.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            let fixedNewCityName = removeSpaceCityName.components(separatedBy: CharacterSet.decimalDigits).joined()
            getWeatherDataForCityName(q: String(describing: fixedNewCityName))
            getForecastDataForCityName(q: String(describing: fixedNewCityName))
        }
        if cityLabel.text == "Connection Issues" {
            currentLocationButton()
        }
    }
    
    // TableViewCell
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellone", for: indexPath) as! ForecastCell
        cell.configureForecastCell(forecastData: forecastArray[indexPath.row])
        return cell
    }
    
    // ************* change tabelViewCell High ************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        height = 70
        return height
    }
    
    //MARK: - Networking
    /************************/
    
    func getWeatherData (latitude: String, longitude:String) {
        let urlStr = "\(FORECAST_URL)\("&q=")\(latitude),\(longitude)"
        Alamofire.request(urlStr, method: .get, parameters: nil).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func getWeatherDataForCityName (q : String) {
        let urlStr = "\(FORECAST_URL)\("&q=")\(q)"
        Alamofire.request(urlStr, method: .get, parameters: nil).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data for city name")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    // get Five Next Days Weather Data
    
    func getForecastData(forecastParams : String ) {
        let urlStr = "\(FORECAST_URL)\("&q=")\(forecastParams)\("&days=7")"
        Alamofire.request(urlStr, method: .get, parameters: nil).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the forecast data")
                self.forecastArray.removeAll()
                let result = response.result
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    if let forecastList = dictionary["forecast"] as?  Dictionary<String, AnyObject> {
                        if let forecastDayList = forecastList["forecastday"] as? [Dictionary<String, AnyObject>]{
                            for item in forecastDayList {
                                let forecast = ForecastDataModel(weatherDict: item)
                                self.forecastArray.append(forecast)
                            }
                        }
                        self.forecastArray.remove(at: 0)
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func getForecastDataForCityName(q : String ) {
        let urlStr = "\(FORECAST_URL)\("&q=")\(q)\("&days=7")"
        Alamofire.request(urlStr, method: .get, parameters: nil).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the forecast data for City Name")
                self.forecastArray.removeAll()
                let result = response.result
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    if let forecastList = dictionary["forecast"] as?  Dictionary<String, AnyObject> {
                        if let forecastDayList = forecastList["forecastday"] as? [Dictionary<String, AnyObject>]{
                            for item in forecastDayList {
                                let forecast = ForecastDataModel(weatherDict: item)
                                self.forecastArray.append(forecast)
                            }
                        }
                        self.forecastArray.remove(at: 0)
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parsing
    /************************/
    
    //Update Weather Data
    
    func updateWeatherData(json : JSON) {
        if let tempResult = json["current"]["temp_c"].double {
            weatherDataModel.temperature = String(Int(Double(tempResult).rounded()))
            let feelsLikeResult = json["current"]["feelslike_c"].doubleValue
            weatherDataModel.feelsLike = String(Int(Double(feelsLikeResult).rounded()))
            weatherDataModel.city = json["location"]["name"].stringValue
            weatherDataModel.humidity = Int(json["current"]["humidity"].doubleValue)
            weatherDataModel.pressure = Int(json["current"]["pressure_mb"].doubleValue)
            let windSpeedResult = json["current"]["wind_mph"].doubleValue
            weatherDataModel.windSpeed = String(format: "%g", (windSpeedResult * 1.609).rounded())
            weatherDataModel.windDirection = json["current"]["wind_dir"].stringValue
            weatherDataModel.precipitation = json["current"]["precip_mm"].stringValue
            
            // Sunrise and Sunset
            
            let sunriseResult = json["forecast"]["forecastday"][0]["astro"]["sunrise"].stringValue
            weatherDataModel.sunrise = sunriseResult
            let sunsetResult = json["forecast"]["forecastday"][0]["astro"]["sunset"].stringValue
            weatherDataModel.sunset = sunsetResult
            
            // visibility
            
            let visibilityResult = json["current"]["vis_km"].doubleValue
            if visibilityResult >= 1 {
                weatherDataModel.visibility = String(visibilityResult) + " km"
            }
            else {
                weatherDataModel.visibility = String(Int(visibilityResult * 1000)) + " m"
            }
            
            // date
            
            let curDate = json["forecast"]["forecastday"][0]["date_epoch"].double
            let convertedDate = Date(timeIntervalSince1970: curDate!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            weatherDataModel.currentDate = dateFormatter.string(from: convertedDate)
            
            let todayName = DateFormatter()
            todayName.timeZone = TimeZone(abbreviation: "UTC")
            todayName.dateFormat = "EEEE"
            weatherDataModel.weekday = todayName.string(from: convertedDate)
            
            // ******** Weather Condition and Weather Icon
            
            weatherDataModel.iconCondition = json["current"]["is_day"].stringValue
            weatherDataModel.condition = json["current"]["condition"]["code"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.weatherCondition = json["current"]["condition"]["text"].stringValue
            
            updateUIWithWeatherData()
        }
        else   {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    /************************/
    
    //update UI weather data
    
    func updateUIWithWeatherData () {
        cityLabel.text = weatherDataModel.city
        tempLabel.text = String(weatherDataModel.temperature) + " ℃"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        weatherConditionLabel.text = weatherDataModel.weatherCondition
        dateLabel.text = weatherDataModel.currentDate
        dayLabel.text = weatherDataModel.weekday
        feelsLikeLabel.text = "Feels Like: " + weatherDataModel.feelsLike
        humidityLabel.text = "Humidity: " + String(weatherDataModel.humidity) + " %"
        pressureLabel.text = "Pressure: " + String(weatherDataModel.pressure) + " hPa"
        windLable.text = "Wind: " + String(weatherDataModel.windSpeed) + " km/h"
        windDirectionLabel.text = "Wind direction: " + String(weatherDataModel.windDirection)
        visibilityLabel.text = "Visibility: " + String(weatherDataModel.visibility)
        precipitationLabel.text = "Precipitation: " + String(weatherDataModel.precipitation) + "mm"
        sunriseLabel.text = "Sunrise: " + weatherDataModel.sunrise
        sunsetLabel.text = "Sunset: " + weatherDataModel.sunset
    }
    
    //MARK: - Location Manager Delegate Methods
    /*******************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
        longitude = String(location.coordinate.longitude)
        latitude = String(location.coordinate.latitude)
        forecastParams = "\(latitude)\(",")\(longitude)"
        
        getWeatherData(latitude : latitude, longitude : longitude)
        getForecastData(forecastParams: forecastParams )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    //MARK: - Change City Delegate methods
    /**************************************/
    
    func userEnteredANewCityName(city: String) {
        getWeatherDataForCityName(q: city)
        getForecastDataForCityName(q: city)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self as ChangeCityDelegate
        }
    }
}
