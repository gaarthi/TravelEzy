//
//  PlaceDetailViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 24/01/22.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var selectedPlaceCollectionView: UICollectionView!
    @IBOutlet weak var placeMapView: MKMapView!
    
    var placeRating: String?
    var selectedPlace = Place(p_name: "", p_imageone: "", p_imagetwo: "", p_imagethree: "", p_rating: "", p_description: "", p_latitude: "", p_longitude: "")
    var imageArray = [UIImage]()
    typealias imageData = (([UIImage]) -> Void)
    var timer = Timer()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeMapView.delegate = self
        configureUI()
        showMapView()
    }
    
    func configureUI() {
        placeNameLabel.text = selectedPlace.placeName
        placeDescriptionLabel.text = selectedPlace.description
        placeRating = selectedPlace.rating
        switch placeRating {
        case "1":
            ratingImageView.image = UIImage(named: "star-1")
        case "2":
            ratingImageView.image = UIImage(named: "star-2")
        case "3":
            ratingImageView.image = UIImage(named: "star-3")
        case "4":
            ratingImageView.image = UIImage(named: "star-4")
        case "5":
            ratingImageView.image = UIImage(named: "star-5")
        default:
            print("default")
        }
        
        var urls = [selectedPlace.placeImageOne!, selectedPlace.placeImageTwo!, selectedPlace.placeImageThree!]
        self.displayImage(imageURLs: urls) { imgarray in
            DispatchQueue.main.async {
                self.selectedPlaceCollectionView.reloadData()
                if imgarray.count > 0 {
                    self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    // Setting Timer
    @objc func changeImage() {
        if count < imageArray.count {
            let index = IndexPath.init(item: count, section: 0)
            self.selectedPlaceCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            count += 1
        } else {
            count = 0
            let index = IndexPath.init(item: count, section: 0)
            self.selectedPlaceCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            count = 1
        }
    }
    
    func displayImage(imageURLs: [String], imageData: @escaping imageData) {
        
        for each in imageURLs {
            guard let url = URL(string: each) else {
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    var image = UIImage(data: data)
                    self.imageArray.append(image!)
                    imageData(self.imageArray)
                }
            }.resume()
        }
    }
    
    func showMapView() {
        let latitude: CLLocationDegrees = ((selectedPlace.latitude)! as NSString).doubleValue
        let longitude: CLLocationDegrees = ((selectedPlace.longitude)! as NSString).doubleValue
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        placeMapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = selectedPlace.placeName
        placeMapView.addAnnotation(annotation)
    }
    
}

extension PlaceDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedPlaceCell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            if imageArray.count > 0 {
                vc.image = imageArray[indexPath.row]
            }
            else {
                print("No images")
            }
        }
        return cell
    }
}
