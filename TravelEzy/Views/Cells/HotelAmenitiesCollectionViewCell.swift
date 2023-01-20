//
//  HotelAmenitiesCollectionViewCell.swift
//  TravelEzy
//
//  Created by Aarthi on 06/04/22.
//

import UIKit

class HotelAmenitiesCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = #colorLiteral(red: 0.003499795916, green: 0.7116407752, blue: 0.7581144571, alpha: 1)
    }

}
