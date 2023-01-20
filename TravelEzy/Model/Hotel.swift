//
//  Hotel.swift
//  TravelEzy
//
//  Created by Aarthi on 07/03/22.
//

import Foundation

struct Hotel: Hashable {
    var name: String?
    var imageURL: String?
    var address: String?
    var price: String?
    var rating: String?
    var description: String?
    var facilities: [String]?
    var roomType: [String]?
    var roomPrice: [String]?
    
    init(h_name: String, h_imageURL: String, h_address: String, h_price: String, h_rating: String, h_description: String, h_facilities: [String], h_roomType: [String], h_roomPrice: [String]) {
        self.name = h_name
        self.imageURL = h_imageURL
        self.address = h_address
        self.price = h_price
        self.rating = h_rating
        self.description = h_description
        self.facilities = h_facilities
        self.roomType = h_roomType
        self.roomPrice = h_roomPrice
    }
}
