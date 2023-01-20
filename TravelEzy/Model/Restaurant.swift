//
//  Restaurant.swift
//  TravelEzy
//
//  Created by Aarthi on 26/03/22.
//

import Foundation

struct Restaurant {
    
    var name: String?
    var address: String?
    var price: String?
    var cuisine: String?
    var rating: String?
    var numberOfReviews: String?
    var costType: String?
    var timing: String?
    var menuItems: [Item]?
    
    init(r_name: String, r_address: String, r_price: String, r_cuisine: String, r_rating: String, r_reviews: String, r_costType: String, r_timing: String, r_menuItems: [Item]) {
        self.name = r_name
        self.address = r_address
        self.price = r_price
        self.cuisine = r_cuisine
        self.rating = r_rating
        self.numberOfReviews = r_reviews
        self.costType = r_costType
        self.timing = r_timing
        self.menuItems = r_menuItems
    }
}

struct Item {
    var itemName: String?
    var itemPrice: String?
    var itemImage: String?
    
    init(i_name: String, i_price: String, i_image: String) {
        self.itemName = i_name
        self.itemPrice = i_price
        self.itemImage = i_image
    }
    }
