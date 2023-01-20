//
//  CitySelectionViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 17/04/22.
//

import UIKit
import DropDown
import Firebase
import BottomPopup

var selectedCountryName = String()
var selectedStateName = String()
var selectedCityName = String()
var timeZoneAbbreviation = String()

class CitySelectionViewController: BottomPopupViewController {
    
    var height: CGFloat?
    override var popupHeight: CGFloat { height ?? 300.0 }
    let dropDown = DropDown()
    var countryData: [Country] = []
    typealias completionHandler = (([Country]) -> Void)
    let ref = Database.database().reference(withPath: "Countries")
    
    @IBOutlet weak var selectCountryBtn: UIButton!
    @IBOutlet weak var selectStateBtn: UIButton!
    @IBOutlet weak var selectCityBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectCountryTapped(_ sender: UIButton) {
        
        self.fetchDataFromFirebase { array in
            var data = [String]()
            for each in array {
                data.append(each.country)
            }
            self.dropDown.dataSource = data
        }
        dropDown.anchorView = sender
        DropDown.appearance().selectedTextColor = #colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1)
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func selectStateTapped(_ sender: UIButton) {
        
        self.fetchDataFromFirebaseForState(selectedCountry: (selectCountryBtn.titleLabel?.text)!, countryData: { array in
            var data = [String]()
            for each in array {
                data.append(each.country)
            }
            self.dropDown.dataSource = data
        })
        dropDown.anchorView = sender
        DropDown.appearance().selectedTextColor = #colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1)
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func selectCityTapped(_ sender: UIButton) {
        self.fetchDataFromFirebaseForCity(selectedCountry: (selectCountryBtn.titleLabel?.text)!, selectedState: (selectStateBtn.titleLabel?.text)!, countryData: { array in
            var data = [String]()
            for each in array {
                data.append(each.country)
            }
            self.dropDown.dataSource = data
        })
        dropDown.anchorView = sender
        DropDown.appearance().selectedTextColor = #colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1)
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
        }
    }
    
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "guestSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "guestSegue" {
            selectedCountryName = (selectCountryBtn.titleLabel?.text)!
            selectedStateName = (selectStateBtn.titleLabel?.text)!
            selectedCityName = (selectCityBtn.titleLabel?.text)!
            var abbreviation = getAbbreviationForSelectedPlace(c_name: selectedCountryName, s_name: selectedStateName)
            timeZoneAbbreviation = abbreviation
        }
    }
    
    func getAbbreviationForSelectedPlace(c_name: String, s_name: String) -> String {
        switch c_name {
        case "India":
            return "IST"
        case "United States":
            var test = ""
            if s_name == "Alabama" {
                test = US.alabama.timeZoneAbbreviationForState()
            } else if s_name == "California" {
                test = US.california.timeZoneAbbreviationForState()
            } else if s_name == "New York" {
                test = US.newYork.timeZoneAbbreviationForState()
            }
            return test
        default:
            return "IST"
        }
        
    }
    
    func fetchDataFromFirebase(countryData: @escaping completionHandler) {
        
        self.countryData = []
        self.ref.observeSingleEvent(of: .value) { snap in
            guard let value = snap.value as? [String:Any] else
            { return }
            for (key, val) in value {
                let data = Country(u_country: key as! String)
                self.countryData.append(data)
                countryData(self.countryData)
            }
        }
    }
    
    func fetchDataFromFirebaseForState(selectedCountry: String, countryData: @escaping completionHandler) {
        
        self.countryData = []
        self.ref.child(selectedCountry).observeSingleEvent(of: .value) { snap in
            guard let value = snap.value as? [String:Any] else
            { return }
            for (key, val) in value {
                let data = Country(u_country: key as! String)
                self.countryData.append(data)
                countryData(self.countryData)
            }
        }
    }
    
    func fetchDataFromFirebaseForCity(selectedCountry: String, selectedState: String, countryData: @escaping completionHandler) {
        
        self.countryData = []
        self.ref.child(selectedCountry).child(selectedState).observeSingleEvent(of: .value) { snap in
            guard let value = snap.value as? [String:Any] else
            { return }
            for (key, val) in value {
                self.ref.child(selectedCountry).child(selectedState).child(key).observeSingleEvent(of: .value) { snap in
                    guard let value = snap.value as? [String:Any] else
                    { return }
                    for (key1, val1) in value {
                        let data = Country(u_country: val1 as! String)
                        self.countryData.append(data)
                        countryData(self.countryData)
                    }
                }
            }
        }
    }
}
