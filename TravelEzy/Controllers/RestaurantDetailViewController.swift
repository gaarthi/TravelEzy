//
//  RestaurantDetailViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 21/02/22.
//

import UIKit
import SVProgressHUD

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var costTypeLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var numberofReviewsLabel: UILabel!
    @IBOutlet weak var reserveTableButton: UIButton!
    @IBOutlet weak var menuItemCollectionView: UICollectionView!
    
    var restaurantRating: String?
    var selectedRestaurant = Restaurant(r_name: "", r_address: "", r_price: "", r_cuisine: "", r_rating: "", r_reviews: "", r_costType: "", r_timing: "", r_menuItems: [])
    var itemsArray = [Item]()
    var imageArray: [UIImage] = []
    var imageURLs: [String] = []
    var globalArray: [String] = []
    var itemPrice: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        menuItemCollectionView.register(UINib(nibName: "MenuItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuItemCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset.right = 10
        layout.sectionInset.left = 10
        layout.sectionInset.top = 10
        layout.sectionInset.bottom = 10
        menuItemCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func configureUI() {
        nameLabel.text = selectedRestaurant.name
        addressLabel.text = selectedRestaurant.address
        priceLabel.text = selectedRestaurant.price
        cuisineLabel.text = selectedRestaurant.cuisine
        numberofReviewsLabel.text = "(\(selectedRestaurant.numberOfReviews!) reviews)"
        costTypeLabel.text = selectedRestaurant.costType
        timingLabel.text = selectedRestaurant.timing
        
        restaurantRating = selectedRestaurant.rating
        switch restaurantRating {
        case "1":
            ratingImage.image = UIImage(named: "star-1")
        case "2":
            ratingImage.image = UIImage(named: "star-2")
        case "3":
            ratingImage.image = UIImage(named: "star-3")
        case "4":
            ratingImage.image = UIImage(named: "star-4")
        case "5":
            ratingImage.image = UIImage(named: "star-5")
        default:
            print("default")
        }
        
        itemsArray = selectedRestaurant.menuItems!
    }
    
    @IBAction func reserveTableBtnTapped(_ sender: UIButton) {
        AlertManager.showBasicAlert(title: "Want to book a Table?", message: "Become a Pro User Now to enjoy all benefits!", vc: self)
    }
}

extension RestaurantDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return selectedRestaurant.menuItems!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItemCell", for: indexPath) as! MenuItemCollectionViewCell
        cell.itemName.text = selectedRestaurant.menuItems![indexPath.row].itemName!
        cell.itemPrice.text = selectedRestaurant.menuItems![indexPath.row].itemPrice!
        cell.itemImage.downloadImage(urlString: selectedRestaurant.menuItems![indexPath.row].itemImage!)

        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowlayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowlayout?.minimumInteritemSpacing ?? 0.0) + (flowlayout?.sectionInset.left ?? 0.0) + (flowlayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (menuItemCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}



