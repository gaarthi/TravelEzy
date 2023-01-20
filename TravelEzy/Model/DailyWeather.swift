//
//  DailyWeather.swift
//  TravelEzy
//
//  Created by Aarthi on 31/03/22.
//

import Foundation

struct DailyWeather {
    var daily: [DailyForecast]?
   
    init(w_daily: [DailyForecast]) {
        self.daily = w_daily
    }
}

struct DailyForecast {
    var temp: Temperature?
   
    init(d_temp: Temperature) {
        self.temp = d_temp
    }
}

struct Temperature {
    var day: Float?
    var min: Float?
    var max: Float?
    var night: Float?
    var eve: Float?
    var morn: Float?
    
    init(t_day: Float, t_min: Float, t_max: Float, t_night: Float, t_eve: Float, t_morn: Float) {
        self.day = t_day
        self.min = t_min
        self.max = t_max
        self.night = t_night
        self.eve = t_eve
        self.morn = t_morn
    }
}
