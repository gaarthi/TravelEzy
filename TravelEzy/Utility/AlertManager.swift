//
//  AlertManager.swift
//  TravelEzy
//
//  Created by Aarthi on 23/11/22.
//

import Foundation
import UIKit

class AlertManager {
    class func showBasicAlert(title: String, message:String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: .none)
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
