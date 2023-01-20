//
//  UIViewController+Extensions.swift
//  TravelEzy
//
//  Created by Aarthi on 27/04/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func latitudeForCity(selectedCity: String) -> String {
        switch selectedCity {
        case "Chennai":
            return "13.087"
        case "Cupertino":
            return "37.323"
        default:
            return ""
        }
    }
    
    func longitudeForCity(selectedCity: String) -> String {
        switch selectedCity {
        case "Chennai":
            return "80.278"
        case "Cupertino":
            return "-122.032"
        default:
            return ""
        }
    }
    
}
