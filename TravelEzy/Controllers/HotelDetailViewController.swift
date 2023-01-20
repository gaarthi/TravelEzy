//
//  HotelDetailViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 17/02/22.
//

import UIKit

class HotelDetailViewController: UIViewController {
    
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var hotelDescriptionLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var detailListTableView: UITableView!
    
    var hotelRating: String?
    var selectedHotel = Hotel(h_name: "", h_imageURL: "", h_address: "", h_price: "", h_rating: "", h_description: "", h_facilities: [], h_roomType: [], h_roomPrice: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        displayImage()
        detailListTableView.register(UINib(nibName: "HotelPriceDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "priceDetailCell")
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
    }
    
    func configureUI() {
        hotelNameLabel.text = selectedHotel.name
        hotelAddressLabel.text = selectedHotel.address
        hotelDescriptionLabel.text = selectedHotel.description
        
        hotelRating = selectedHotel.rating
        switch hotelRating {
        case "1":
            ratingImage.image = UIImage(named: "star-1")
        case "2":
            ratingImage.image = UIImage(named: "star-2")
        case "3":
            ratingImage.image = UIImage(named: "star-3")
        case "4":
            ratingImage.image = UIImage(named: "star-4")
        case "5":
            ratingImage.image = UIImage(named: "star-5")
        default:
            print("default")
        }
    }
    
    func displayImage() {
        let imageURL = selectedHotel.imageURL
        guard let url = URL(string: imageURL!) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.hotelImage.image = image
            }
        }.resume()
    }
    
    @objc func handleSegmentChange() {
        detailListTableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bookHotelBtnTapped(_ sender: UIButton) {
        AlertManager.showBasicAlert(title: "Want to book a Room?", message: "Become a Pro User Now to enjoy all benefits!", vc: self)
    }
}

extension HotelDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentedControl.selectedSegmentIndex == 0 ? (selectedHotel.facilities?.count)! : (selectedHotel.roomType?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! UITableViewCell
            cell.textLabel?.text = selectedHotel.facilities![indexPath.row]
            cell.selectionStyle = .none
            return cell
        } else {
            let priceCell = tableView.dequeueReusableCell(withIdentifier: "priceDetailCell", for: indexPath) as! HotelPriceDetailTableViewCell
            priceCell.nameLabel.text = selectedHotel.roomType![indexPath.row]
            priceCell.priceLabel.text = selectedHotel.roomPrice![indexPath.row]
            priceCell.selectionStyle = .none
            return priceCell
        }
    }
}
