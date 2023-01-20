//
//  CountryInputViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 18/04/22.
//

import UIKit
import Firebase


class CountryInputViewController: UIViewController {
    
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    
    let ref = Database.database().reference(withPath: "Countries")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        let childRef = self.ref.child(countryTF.text!).child(stateTF.text!)
        let autoID = childRef.childByAutoId()
        let cityRef = autoID.child("CName")
        
        cityRef.setValue(cityTF.text)
        clearCountryInputs()
    }
    
    func clearCountryInputs() {
        countryTF.text = ""
        stateTF.text = ""
        cityTF.text = ""
    }
}
