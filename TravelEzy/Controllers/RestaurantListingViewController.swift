//
//  RestaurantListingViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 21/02/22.
//

import UIKit
import Firebase
import SVProgressHUD

class RestaurantListingViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var restaurantListingTableView: UITableView!
    
    var restaurantData = [Restaurant]()
    var itemData = [Item]()
    let ref = Database.database().reference(withPath: "Restaurants")
    typealias completionHandler = (([Restaurant]) -> Void)
    var filteredArray = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantListingTableView.register(UINib(nibName: "RestaurantListingTableViewCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        configureInitialUI()
    }
    
    func configureInitialUI() {
        
        self.restaurantData = []
        SVProgressHUD.show()
        WebService.sharedInstance.fetchFromFirebase(parentName: "Restaurants", cityName: selectedCityName) { array in
            
            for (key, val) in array  {
                let nextItem = val as! [String:Any]
                let name = nextItem["Name"] as! String
                let address = nextItem["Address"] as! String
                let estimatedCost = nextItem["Estimated Cost"] as! String
                let cuisine = nextItem["Cuisine"] as! String
                let rating = nextItem["Rating"] as! String
                let numberofReview = nextItem["Number of Reviews"] as! String
                let costType = nextItem["Cost Type"] as! String
                let timings = nextItem["Timings"] as! String
                let menuItems = nextItem["Menu Items"] as! [String:Any]
                
                for (key2, val2) in menuItems {
                    let eachItem = val2 as! [String:Any]
                    let itemName = eachItem["Item Name"] as! String
                    let itemPrice = eachItem["Item Cost"] as! String
                    let itemImage = eachItem["Item Image"] as! String
                    
                    let itemData = Item(i_name: itemName, i_price: itemPrice, i_image: itemImage)
                    self.itemData.append(itemData)
                }
                let data = Restaurant(r_name: name, r_address: address, r_price: estimatedCost, r_cuisine: cuisine, r_rating: rating, r_reviews: numberofReview, r_costType: costType, r_timing: timings, r_menuItems: self.itemData)
                self.restaurantData.append(data)
                self.itemData = []
            }
            SVProgressHUD.dismiss()
            self.filteredArray = self.restaurantData
            self.restaurantListingTableView.reloadData()
        }
    }
}

extension RestaurantListingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = restaurantListingTableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantListingTableViewCell
        cell.nameLabel.text = filteredArray[indexPath.row].name
        cell.addressLabel.text = filteredArray[indexPath.row].address
        cell.priceLabel.text = filteredArray[indexPath.row].price
        cell.cuisineLabel.text = filteredArray[indexPath.row].cuisine
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.selectedRestaurant = restaurantData[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
}

extension RestaurantListingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filteredArray = self.restaurantData
            restaurantListingTableView.reloadData()
            return
        }
        filteredArray = restaurantData.filter({
            ($0.name!.prefix(searchText.count) == searchText)
        })
        restaurantListingTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        filteredArray = restaurantData
        restaurantListingTableView.reloadData()
    }
}
