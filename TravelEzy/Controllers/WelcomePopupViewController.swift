//
//  WelcomePopupViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 20/04/22.
//

import UIKit

class WelcomePopupViewController: UIViewController {
    
    let img = UIImageView()
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        descriptionLabel.text = "Landed in a new city?\nDon't worry, we are here to help you! Check out our app to explore the city."
        img.image = UIImage(named: "Plane-1")
        self.popupView.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 55).isActive = true
        img.widthAnchor.constraint(equalToConstant: 55).isActive = true
        img.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
        img.centerYAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        self.view.layoutIfNeeded()
        img.backgroundColor = UIColor.white
        img.layer.cornerRadius = img.bounds.size.width/2
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.layer.borderWidth = 2.0
        img.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        img.contentMode = .scaleAspectFit
    }
    
    @IBAction func dismissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
