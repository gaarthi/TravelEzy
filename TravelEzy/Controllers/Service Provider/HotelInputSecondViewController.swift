//
//  HotelInputSecondViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 11/03/22.
//

import UIKit
import Firebase

class HotelInputSecondViewController: UIViewController {
    
    @IBOutlet weak var wiFiSwitch: UISwitch!
    @IBOutlet weak var parkingSwitch: UISwitch!
    @IBOutlet weak var airConditioningSwitch: UISwitch!
    @IBOutlet weak var swimmingPoolSwitch: UISwitch!
    @IBOutlet weak var spaSwitch: UISwitch!
    @IBOutlet weak var gymSwitch: UISwitch!
    @IBOutlet weak var playAreaSwitch: UISwitch!
    @IBOutlet weak var roomServiceSwitch: UISwitch!
    @IBOutlet weak var laundrySwitch: UISwitch!
    @IBOutlet weak var airportTransferSwitch: UISwitch!
    @IBOutlet weak var roomTypeTF: UITextField!
    @IBOutlet weak var roomPriceTF: UITextField!
    
    var array: [UISwitch] = []
    var wiFiFlag: Int = 0
    var parkingFlag: Int = 0
    var airConditioningFlag: Int = 0
    var swimmingPoolFlag: Int = 0
    var spaFlag: Int = 0
    var gymFlag: Int = 0
    var playAreaFlag: Int = 0
    var roomServiceFlag: Int = 0
    var laundryFlag: Int = 0
    var airportTransferFlag: Int = 0
    var facilitiesArray: [String] = []
    var roomTypes: [String] = []
    var roomPrices: [String] = []
    var savedData: [String] = []
    let ref = Database.database().reference(withPath: "Hotels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSwitches()
    }
    
    func configureSwitches() {
        wiFiSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        parkingSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        airConditioningSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        swimmingPoolSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        spaSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        gymSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        playAreaSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        roomServiceSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        laundrySwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        airportTransferSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            switch switchState.tag {
            case 0:
                wiFiFlag = 1
                self.facilitiesArray.append("Wi-Fi")
            case 1:
                parkingFlag = 1
                self.facilitiesArray.append("Parking")
            case 2:
                airConditioningFlag = 1
                self.facilitiesArray.append("Air-Conditioning")
            case 3:
                swimmingPoolFlag = 1
                self.facilitiesArray.append("Swimming Pool")
            case 4:
                spaFlag = 1
                self.facilitiesArray.append("Spa")
            case 5:
                gymFlag = 1
                self.facilitiesArray.append("Gym")
            case 6:
                playAreaFlag = 1
                self.facilitiesArray.append("Play Area")
            case 7:
                roomServiceFlag = 1
                self.facilitiesArray.append("Room Service")
            case 8:
                laundryFlag = 1
                self.facilitiesArray.append("Laundry Service")
            case 9:
                airportTransferFlag = 1
                self.facilitiesArray.append("Airport Transfer")
                
            default:
                print("default")
            }
        }
        else {
            switch switchState.tag {
            case 0:
                wiFiFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Wi-Fi" }
            case 1:
                parkingFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Parking" }
            case 2:
                airConditioningFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Air-Conditioning" }
            case 3:
                swimmingPoolFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Swimming Pool" }
            case 4:
                spaFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Spa" }
            case 5:
                gymFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Gym" }
            case 6:
                playAreaFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Play Area" }
            case 7:
                roomServiceFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Room Service" }
            case 8:
                laundryFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Laundry Service" }
            case 9:
                airportTransferFlag = 0
                self.facilitiesArray = self.facilitiesArray.filter { $0 != "Airport Transfer" }
            default:
                print("default")
            }
        }
    }
    
    @IBAction func addAnotherRoomDetail(_ sender: UIButton) {
        roomTypes.append(roomTypeTF.text!)
        roomPrices.append(roomPriceTF.text!)
        roomTypeTF.text = ""
        roomPriceTF.text = ""
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        if roomTypeTF.text != nil {
            roomTypes.append(roomTypeTF.text!)
        }
        if roomPriceTF.text != nil {
            roomPrices.append(roomPriceTF.text!)
        }
        saveToFirebase(array: self.facilitiesArray)
    }
    
    func saveToFirebase(array: [String]) {
        let childRef = self.ref.child(savedData[0]).childByAutoId()
        let nameRef = childRef.child("Name")
        let imageRef = childRef.child("ImageURL")
        let addressRef = childRef.child("Address")
        let priceRef = childRef.child("Price")
        let ratingRef = childRef.child("Rating")
        let descriptionRef = childRef.child("Description")
        
        let facilitiesRef = childRef.child("Facilities")
        facilitiesRef.setValue(self.facilitiesArray)
        let roomTypeRef = childRef.child("Room Type")
        let roomPriceRef = childRef.child("Room Price")
        
        nameRef.setValue(savedData[1])
        imageRef.setValue(savedData[2])
        addressRef.setValue(savedData[3])
        priceRef.setValue(savedData[4])
        ratingRef.setValue(savedData[5])
        descriptionRef.setValue(savedData[6])
        roomTypeRef.setValue(self.roomTypes)
        roomPriceRef.setValue(self.roomPrices)
        
        print("Saved to firebase")
        displayAlert()
    }
    
    func displayAlert() {
        let alertController = UIAlertController(title: "Details have been saved!", message: "Do you want to add another Hotel detail?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "YES", style: .default) { action in
            self.clearAllInputData()
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "NO", style: .cancel) { action in
            self.clearAllInputData()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func clearAllInputData() {
        wiFiSwitch.setOn(false, animated: false)
        parkingSwitch.setOn(false, animated: false)
        airConditioningSwitch.setOn(false, animated: false)
        swimmingPoolSwitch.setOn(false, animated: false)
        spaSwitch.setOn(false, animated: false)
        gymSwitch.setOn(false, animated: false)
        playAreaSwitch.setOn(false, animated: false)
        roomServiceSwitch.setOn(false, animated: false)
        laundrySwitch.setOn(false, animated: false)
        airportTransferSwitch.setOn(false, animated: false)
        roomTypeTF.text = ""
        roomPriceTF.text = ""
    }
}

extension HotelInputSecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
