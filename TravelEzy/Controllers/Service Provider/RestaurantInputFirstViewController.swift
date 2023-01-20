//
//  RestaurantInputFirstViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 24/03/22.
//

import UIKit
import DropDown

class RestaurantInputFirstViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var estimatedCostTF: UITextField!
    @IBOutlet weak var cuisineTF: UITextField!
    @IBOutlet weak var ratingTF: UITextField!
    @IBOutlet weak var numberofReviewsTF: UITextField!
    @IBOutlet weak var costTypeTF: UITextField!
    @IBOutlet weak var timingTF: UITextField!
    
    let dropDown = DropDown()
    var selectedCity = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectCityBtnTapped(_ sender: UIButton) {
        dropDown.dataSource = ["Cupertino", "Chennai"]
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self?.selectedCity = item
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantInputSecondViewController") as! RestaurantInputSecondViewController
        vc.savedData = [selectedCity, self.nameTF.text!, self.addressTF.text!, self.estimatedCostTF.text!, self.cuisineTF.text!, self.ratingTF.text!, self.numberofReviewsTF.text!, self.costTypeTF.text!, self.timingTF.text!]
        self.present(vc, animated: true, completion: nil)
        
    }
}

extension RestaurantInputFirstViewController: UITextFieldDelegate {
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
