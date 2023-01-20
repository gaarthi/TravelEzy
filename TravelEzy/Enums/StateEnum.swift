//
//  StateEnum.swift
//  TravelEzy
//
//  Created by Aarthi on 19/04/22.
//

import Foundation

enum US {
    case alabama
    case california
    case newYork
    
    func timeZoneAbbreviationForState() -> String {
        switch (self) {
        case .alabama:
            return "CDT"
        case .california:
            return "PDT"
        case .newYork:
            return "EDT"
        }
    }
}
