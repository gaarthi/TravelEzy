//
//  City.swift
//  TravelEzy
//
//  Created by Aarthi on 19/03/22.
//

import Foundation

struct City {
    var cityName: String?
    var cityImageOne: String?
    var cityImageTwo: String?
    var cityImageThree: String?
    var places: [Place]?
   
    init(c_name: String, c_imageone: String, c_imagetwo: String, c_imagethree: String, places: [Place]) {
        self.cityName = c_name
        self.cityImageOne = c_imageone
        self.cityImageTwo = c_imagetwo
        self.cityImageThree = c_imagethree
        self.places = places
    }
}

struct Place {
    var placeName: String?
    var placeImageOne: String?
    var placeImageTwo: String?
    var placeImageThree: String?
    var rating: String?
    var description: String?
    var latitude: String?
    var longitude: String?
    
    init(p_name: String, p_imageone: String, p_imagetwo: String, p_imagethree: String, p_rating: String, p_description: String, p_latitude: String, p_longitude: String) {
        self.placeName = p_name
        self.placeImageOne = p_imageone
        self.placeImageTwo = p_imagetwo
        self.placeImageThree = p_imagethree
        self.rating = p_rating
        self.description = p_description
        self.latitude = p_latitude
        self.longitude = p_longitude
    }
}
