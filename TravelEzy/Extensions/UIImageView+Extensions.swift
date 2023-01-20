//
//  UIImageView+Extensions.swift
//  TravelEzy
//
//  Created by Aarthi on 04/11/22.
//

import Foundation
import UIKit
import SVProgressHUD
import Kingfisher
import SwiftyGif

extension UIImageView {
    
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        
        if self.image == nil{
            // Try using Gif image
            //let gifImage = UIImage.gifImageWithName("Loading_Icon")
            do {
                let gif = try UIImage(gifName: "Loading_Icon.gif")
                self.image = gif
            } catch {
            }
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
                
            })
        }).resume()
    }
    
    func downloadImage(urlString: String) {
        let url = URL(string: urlString)
        self.kf.setImage(with: url)
        do {
            let gif = try UIImage(gifName: "Loading_Icon.gif")
            self.kf.setImage(
                with: url,
                placeholder: gif,
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        } catch {
            
        }
    }
}
