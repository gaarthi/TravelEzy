//
//  UITextField+Extensions.swift
//  TravelEzy
//
//  Created by Aarthi on 21/05/22.
//

import Foundation
import  UIKit

extension UITextField {
    
    func showBottomBorderForTF(textfield: UITextField) -> UITextField {
        
        let bottomLineOne = CALayer()
        bottomLineOne.frame = CGRect(x: 0, y: Int(textfield.frame.height)-2, width: Int(textfield.frame.width), height: 2)
        
        bottomLineOne.backgroundColor = UIColor.black.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLineOne)
        textfield.backgroundColor = .clear
        if textfield.tag == 1 {
            textfield.attributedPlaceholder = NSAttributedString(
                string: "USERNAME",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
            )
        } else if textfield.tag == 2 {
            textfield.attributedPlaceholder = NSAttributedString(
                string: "PASSWORD",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
            )
        }
        
        return textfield
    }
    
}
