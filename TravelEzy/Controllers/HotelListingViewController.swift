//
//  HotelListingViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 17/02/22.
//

import UIKit
import Firebase
import SVProgressHUD

var globalHotelData = [Hotel]()

class HotelListingViewController: UIViewController, UIPopoverPresentationControllerDelegate, SortOptionView, selectedFiltersDelegate {
    
    var fromFilterVC: String?
    var noMatchingDataFound = false
    
    func appliedFilters(filterPriceValue: Int, filterRatingArray: [String], filterFacilityArray: [String], hotelSet: [Hotel]) {
        
        fromFilterVC = "yes"
        var mydata = [Hotel]()
        var filtersApplied = Bool()
        
        hotelSet.filter { array in
            if filterPriceValue == 0 && filterRatingArray.count == 0 && filterFacilityArray.count == 0
            {
                filtersApplied = false
            }
            else if filterPriceValue != 0 && filterRatingArray.count == 0 && filterFacilityArray.count == 0
            {
                if Int(array.price!)! <= filterPriceValue {
                    mydata.append(array)
                }
                filtersApplied = true
            }
            else if filterPriceValue == 0 && filterRatingArray.count > 0 && filterFacilityArray.count == 0
            {
                for each in filterRatingArray {
                    if array.rating!.contains(each) {
                        mydata.append(array)
                    }
                }
                filtersApplied = true
            }
            else if filterPriceValue == 0 && filterRatingArray.count == 0 && filterFacilityArray.count > 0
            {
                for each in filterFacilityArray {
                    if array.facilities!.contains(each) {
                        mydata.append(array)
                    }
                }
                filtersApplied = true
            }
            else if filterPriceValue != 0 && filterRatingArray.count > 0 && filterFacilityArray.count == 0
            {
                if Int(array.price!)! <= filterPriceValue {
                    for each in filterRatingArray {
                        if array.rating!.contains(each) {
                            mydata.append(array)
                        }
                    }
                }
                filtersApplied = true
            }
            else if filterPriceValue != 0 && filterRatingArray.count == 0 && filterFacilityArray.count > 0
            {
                if Int(array.price!)! <= filterPriceValue {
                    for each in filterFacilityArray {
                        if array.facilities!.contains(each) {
                            mydata.append(array)
                        }
                    }
                }
                filtersApplied = true
            }
            else if filterPriceValue == 0 && filterRatingArray.count > 0 && filterFacilityArray.count > 0
            {
                for each in filterRatingArray {
                    if array.rating!.contains(each) {
                        for each in filterFacilityArray {
                            if array.facilities!.contains(each) {
                                mydata.append(array)
                            }
                        }
                    }
                }
                filtersApplied = true
            }
            else if filterPriceValue != 0 && filterRatingArray.count > 0 && filterFacilityArray.count > 0
            {
                if Int(array.price!)! <= filterPriceValue {
                    for each in filterRatingArray {
                        if array.rating!.contains(each) {
                            for each in filterFacilityArray {
                                if array.facilities!.contains(each) {
                                    mydata.append(array)
                                }
                            }
                        }
                    }
                }
                filtersApplied = true
            }
            return filtersApplied
        }
        
        if filtersApplied == true {
            if !mydata.isEmpty {
                let uniqueUnordered = Array(Set(mydata))
                self.hotelData = uniqueUnordered
                self.hotelListingTableView.reloadData()
            } else {
                noMatchingDataFound = true
            }
        } else {
            self.hotelData = hotelSet
            self.hotelListingTableView.reloadData()
        }
    }
    
    func alertForNoMatchingData() {
        let alert = UIAlertController(title: "No Matches Found!", message: "No matches found for applied filters. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.hotelData = globalHotelData
            self.hotelListingTableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sortOptionSelected(selectedOption: String) {
        sortBasedOnSelectedType(SelectedType: selectedOption)
    }
    
    @IBOutlet weak var hotelListingTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var sortingButton: UIButton!
    
    var hotelData = [Hotel]()
    let ref = Database.database().reference(withPath: "Hotels")
    typealias completionHandler = (([Hotel]) -> ())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hotelListingTableView.register(UINib(nibName: "HotelListingTableViewCell", bundle: nil), forCellReuseIdentifier: "hotelcell")
        filterButton.customizeButton(radiusValue: 10)
        sortingButton.customizeButton(radiusValue: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if fromFilterVC == "yes" {
            if self.noMatchingDataFound == true {
                self.alertForNoMatchingData()
                self.noMatchingDataFound = false
            }
            fromFilterVC = ""
        } else {
            configureInitialUI()
        }
    }
    
    func configureInitialUI() {
        self.hotelData = []
        SVProgressHUD.show()
        WebService.sharedInstance.fetchFromFirebase(parentName: "Hotels", cityName: selectedCityName) { array in
            
            for (key, val) in array   {
                let nextItem = val as! [String:Any]
                let name = nextItem["Name"] as! String
                let imageURL = nextItem["ImageURL"] as! String
                let address = nextItem["Address"] as! String
                let price = nextItem["Price"] as! String
                let rating = nextItem["Rating"] as! String
                let description = nextItem["Description"] as! String
                let facilitiesArray = nextItem["Facilities"] as! [String]
                let roomTypeArray = nextItem["Room Type"] as! [String]
                let roomPriceArray = nextItem["Room Price"] as! [String]
                
                let data = Hotel(h_name: name, h_imageURL: imageURL, h_address: address, h_price: price, h_rating: rating, h_description: description, h_facilities: facilitiesArray, h_roomType: roomTypeArray, h_roomPrice: roomPriceArray)
                self.hotelData.append(data)
            }
            SVProgressHUD.dismiss()
            globalHotelData = self.hotelData
            self.hotelListingTableView.reloadData()
        }
    }
    
    func sortBasedOnSelectedType (SelectedType: String) {
        switch SelectedType {
        case "A-Z":
            hotelData.sort { a, b in
                return a.name! < b.name!
            }
        case "Lowest-Highest":
            hotelData.sort { a, b in
                return Double(a.price!)! < Double(b.price!)!
            }
        case "Highest Rated":
            hotelData.sort { a, b in
                return Int(a.rating!)! > Int(b.rating!)!
            }
        default:
            break
        }
        hotelListingTableView.reloadData()
    }
    
    @IBAction func sortingButtonTapped(_ sender: UIButton) {
        
        let popoverController = self.storyboard?.instantiateViewController(withIdentifier: "DropDownViewController") as! DropDownViewController
        popoverController.delegate = self
        popoverController.modalPresentationStyle = .popover
        popoverController.preferredContentSize.width = 200
        popoverController.preferredContentSize.height = 150
        popoverController.popoverPresentationController?.sourceRect = sender.bounds
        popoverController.popoverPresentationController?.delegate = self
        popoverController.popoverPresentationController?.sourceView = sender
        self.present(popoverController, animated: true, completion: nil)
    }
    
    @available(iOS 13.0, *)
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        vc.hotelDataSet = globalHotelData
        vc.filterDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension HotelListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return hotelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = hotelListingTableView.dequeueReusableCell(withIdentifier: "hotelcell", for: indexPath) as! HotelListingTableViewCell
        cell.nameLabel.text = hotelData[indexPath.row].name
        cell.priceLabel.text = hotelData[indexPath.row].price!
        cell.ratingLabel.text = hotelData[indexPath.row].rating
        cell.addressLabel.text = hotelData[indexPath.row].address
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HotelDetailViewController") as! HotelDetailViewController
        vc.selectedHotel = hotelData[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
}


