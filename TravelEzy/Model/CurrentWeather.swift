//
//  CurrentWeather.swift
//  TravelEzy
//
//  Created by Aarthi on 30/03/22.
//

import Foundation

struct CurrentWeather {
    var main: Main?
   
    init(w_main: Main) {
        self.main = w_main
    }
}

struct Main {
    var temperature: Float?
    var feelsLike: Float?
    var temperatureMinimum: Float?
    var temperatureMaximum: Float?
    var pressure: Float?
    var humidity: Float?
    
    init(w_temp: Float, w_feelsLike: Float, w_tempMin: Float, w_tempMax: Float, w_pressure: Float, w_humidity: Float) {
        self.temperature = w_temp
        self.feelsLike = w_feelsLike
        self.temperatureMinimum = w_tempMin
        self.temperatureMaximum = w_tempMax
        self.pressure = w_pressure
        self.humidity = w_humidity
    }
}
