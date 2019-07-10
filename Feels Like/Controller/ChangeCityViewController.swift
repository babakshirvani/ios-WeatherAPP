//
//  ChangeCityViewController.swift
//  FeelsLike
//
//  Created by Babak Shirvani on 2019-01-23.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit
import GooglePlaces


protocol ChangeCityDelegate {
    func userEnteredANewCityName(city : String)
}

class ChangeCityViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingButton: UIButton!
    
    var cityNameList = [String]()
    var cityName :String = ""
    var delegate : ChangeCityDelegate?
    var cityNameFromGoogle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        load()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        addButton.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city  //suitable filter type
        acController.autocompleteFilter = filter
        acController.tableCellBackgroundColor = UIColor(patternImage: UIImage(named: "autocompleteBackgroun")!)
        acController.primaryTextColor = .white
        acController.secondaryTextColor = .white
        acController.primaryTextHighlightColor = .red
        present(acController, animated: true, completion: nil)
    }
    
    func inseartNewCity() {
        cityNameList.append(cityNameFromGoogle)
        let indexPath = IndexPath(row: cityNameList.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        view.endEditing(true)
        Save()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citynamecell") as! CityNameTableViewCell
        cell.cityNameCellLabel.text = cityNameList[indexPath.row]
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cityNameList.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            Save()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityName = cityNameList[indexPath.row]
        fixCityName()
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func fixCityName() {
        let trimmedString = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        let removeSpaceCityName = trimmedString.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        let fixedNewCityName = removeSpaceCityName.components(separatedBy: CharacterSet.decimalDigits).joined()
        delegate?.userEnteredANewCityName(city: fixedNewCityName)
    }
    
    func Save() {
        UserDefaults.standard.set(cityNameList, forKey: "cities")
    }
    
    func load() {
        if let loadData : [String] = UserDefaults.standard.value(forKey: "cities") as? [String] {
            cityNameList = loadData
            tableView.reloadData()
        }
    }
}

extension ChangeCityViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        print("Place name: \(String(describing: place.name))")
        //        print("Place ID: \(String(describing: place.placeID))")
        //        print("Place attributions: \(String(describing: place.attributions))")
        // Get the place name from 'GMSAutocompleteViewController'
        cityNameFromGoogle = place.name!
        inseartNewCity()
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
