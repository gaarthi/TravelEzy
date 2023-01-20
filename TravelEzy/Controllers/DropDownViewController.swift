//
//  DropDownViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 05/03/22.
//

import UIKit

protocol SortOptionView {
    func sortOptionSelected(selectedOption: String)
}

class DropDownViewController: UIViewController {
    
    @IBOutlet weak var dropDownPickerView: UIPickerView!
    
    var delegate: SortOptionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var sortOptions = ["A-Z", "Lowest-Highest", "Highest Rated"]
}

extension DropDownViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sortOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.sortOptionSelected(selectedOption: sortOptions[row])
        self.dismiss(animated: true, completion: nil)
    }
    
}
