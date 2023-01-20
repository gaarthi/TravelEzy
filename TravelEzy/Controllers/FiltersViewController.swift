//
//  FiltersViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 17/02/22.
//

import UIKit

protocol selectedFiltersDelegate {
    func appliedFilters(filterPriceValue: Int, filterRatingArray: [String], filterFacilityArray: [String], hotelSet: [Hotel])
}

@available(iOS 13.0, *)
class FiltersViewController: UIViewController {
    
    @IBOutlet weak var hotelAmenitiesCollectionView: UICollectionView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var selectedPriceLabel: UILabel!
    
    var clearSelection = false
    var selectedPriceValue = Int()
    var sliderMaxValue = Int()
    var hotelAmenitiesArray:[String] = []
    var selectedButtons = [String]()
    var selectedIndexVal:[IndexPath] = []
    var selectedRatings = [String]()
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
    var hotelDataSet = [Hotel]()
    var filterDelegate: selectedFiltersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hotelAmenitiesArray = ["Wi-Fi", "Parking", "Air-Conditioning", "Swimming Pool", "Spa", "Gym", "Play Area", "Laundry Service", "Airport Transfer", "Room Service"]
        configure()
        hotelAmenitiesCollectionView.register(UINib(nibName: "HotelAmenitiesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "hotelAmenitiesCell")
    }
    
    func configure() {
        for eachBtn in buttons {
            eachBtn.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        selectedPriceLabel.text = "\(currentValue)"
        sliderMaxValue = Int(sender.maximumValue)
        if currentValue == Int(sender.minimumValue) {
            selectedPriceValue = 0
            self.selectedPriceLabel.text = ""
        } else {
            selectedPriceValue = currentValue
        }
    }
    
    @IBAction func ratingCheckboxIsSelected(_ sender: UIButton) {
        
        if sender.imageView?.image == UIImage(systemName: "checkmark.square", withConfiguration: largeConfig) {
            sender.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: largeConfig), for: .normal)
            switch sender.tag {
            case 1:
                selectedRatings.append("1")
            case 2:
                selectedRatings.append("2")
            case 3:
                selectedRatings.append("3")
            case 4:
                selectedRatings.append("4")
            case 5:
                selectedRatings.append("5")
            default:
                print("No rating is selected")
            }
        } else {
            sender.setImage(UIImage(systemName: "checkmark.square", withConfiguration: largeConfig), for: .normal)
            switch sender.tag {
            case 1:
                selectedRatings.removeAll { $0 == "1" }
            case 2:
                selectedRatings.removeAll { $0 == "2" }
            case 3:
                selectedRatings.removeAll { $0 == "3" }
            case 4:
                selectedRatings.removeAll { $0 == "4" }
            case 5:
                selectedRatings.removeAll { $0 == "5" }
            default:
                print("Remove selected ratings")
            }
        }
    }
    
    @IBAction func applyFiltersBtnTapped(_ sender: UIButton) {
        filterDelegate?.appliedFilters(filterPriceValue: selectedPriceValue, filterRatingArray: selectedRatings, filterFacilityArray: selectedButtons, hotelSet: hotelDataSet)
        self.dismiss(animated: true)
    }
    
    @IBAction func clearFiltersBtnTapped(_ sender: UIButton) {
        clearAllFilters()
    }
    
    func clearAllFilters() {
        self.priceSlider.value = 0
        self.selectedPriceLabel.text = ""
        self.selectedPriceValue = 0
        self.configure()
        self.selectedRatings.removeAll()
        self.selectedIndexVal.removeAll()
        self.selectedButtons.removeAll()
        self.hotelAmenitiesCollectionView.reloadData()
    }
}

@available(iOS 13.0, *)
extension FiltersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelAmenitiesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotelAmenitiesCell", for: indexPath) as! HotelAmenitiesCollectionViewCell
        cell.nameLabel.text = hotelAmenitiesArray[indexPath.row]
        
        if selectedIndexVal.contains(indexPath) {
            cell.nameLabel.textColor = UIColor.white
            cell.bgView.backgroundColor = #colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1)
        } else {
            cell.nameLabel.textColor = #colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1)
            cell.bgView.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Int((Int(hotelAmenitiesCollectionView.frame.size.width) - 30) / 2)
        return CGSize(width: width, height: 50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let strData = hotelAmenitiesArray[indexPath.item]
        if selectedIndexVal.contains(indexPath) {
            selectedIndexVal = selectedIndexVal.filter { $0 != indexPath }
            selectedButtons = selectedButtons.filter {$0 != strData }
        } else {
            selectedIndexVal.append(indexPath)
            selectedButtons.append(strData)
        }
        self.hotelAmenitiesCollectionView.reloadData()
    }
}


