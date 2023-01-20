//
//  Theme.swift
//  TravelEzy
//
//  Created by Aarthi on 18/01/22.
//

import Foundation
import UIKit

struct Theme {
    
    struct Color {
        static let base = #colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1)
        static let grey = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    struct Font {
        static let black = UIFont(name: "SFUIDisplay-Black", size: 40)
        static let semiBold = UIFont(name: "SFCompactText-Semibold", size: 40)
        static let regular = UIFont(name: "SFUIDisplay-Regular", size: 40)
        static let light = UIFont(name: "SFUIDisplay-Light", size: 40)
        static let lightItalic = UIFont(name: "SFCompactText-LightItalic", size: 40)
        static let ultraLight = UIFont(name: "SFUIDisplay-Ultralight", size: 40)
    }
}



