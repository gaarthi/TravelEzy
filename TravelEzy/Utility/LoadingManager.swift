//
//  LoadingManager.swift
//  TravelEzy
//
//  Created by Aarthi on 22/04/22.
//

import Foundation
import SVProgressHUD

class LoadingManager {
    
    // MARK: - Public
    
    static func configureDefaultAppearance() {
        setupSVProgressHUD()
    }
    
    // MARK: - Private
    
    private static func setupSVProgressHUD() {
        
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setRingNoTextRadius(40)
        SVProgressHUD.setMinimumSize(CGSize(width: 90, height: 90))
        SVProgressHUD.setMinimumDismissTimeInterval(5)
        SVProgressHUD.setRingThickness(8)
    }
}
