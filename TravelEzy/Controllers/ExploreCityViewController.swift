//
//  ExploreCityViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 24/01/22.
//

import UIKit
import Firebase
import SVProgressHUD

class ExploreCityViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var placeCollectionView: UICollectionView!
    
    var timer = Timer()
    var count = 0
    var cityData: City?
    var placeData = [Place]()
    let ref = Database.database().reference(withPath: "Cities")
    typealias completionHandler = ((City) -> Void)
    var imageArray: [UIImage] = []
    typealias imageData = (([UIImage]) -> Void)
    var placeImageUrls: [String] = []
    var placeimageArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeCollectionView.register(UINib(nibName: "PlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "placeCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 35
        layout.sectionInset.right = 20
        layout.sectionInset.left = 20
        layout.sectionInset.top = 20
        layout.sectionInset.bottom = 20
        placeCollectionView.setCollectionViewLayout(layout, animated: true)
        configureInitialUI()
    }
    
    
    // Setting Timer
    @objc func changeImage() {
        if count < imageArray.count {
            let index = IndexPath.init(item: count, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            count += 1
        } else {
            count = 0
            let index = IndexPath.init(item: count, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            count = 1
        }
    }
    
    func configureInitialUI() {
        
        SVProgressHUD.show()
        WebService.sharedInstance.fetchFromFirebase(parentName: "Cities", cityName: selectedCityName) { array in
            
            for (key, val) in array   {
                let item = val as! [String:Any]
                let cityName = item["City Name"] as! String
                let cityImageOne = item["ImageURLOne"] as! String
                let cityImageTwo = item["ImageURLTwo"] as! String
                let cityImageThree = item["ImageURLThree"] as! String
                let placesArray = item["Places"] as! [String:Any]
                for (key1, val1) in placesArray {
                    let placeItem = val1 as! [String:Any]
                    let placeName = placeItem["Place Name"] as! String
                    let placeDescription = placeItem["Description"] as! String
                    let placeImageOne = placeItem["Place ImageURLOne"] as! String
                    let placeImageTwo = placeItem["Place ImageURLTwo"] as! String
                    let placeImageThree = placeItem["Place ImageURLThree"] as! String
                    let placeLatitude = placeItem["Latitude"] as! String
                    let placeLongitude = placeItem["Longitude"] as! String
                    let placeRating = placeItem["Rating"] as! String
                    let placeData = Place(p_name:placeName, p_imageone: placeImageOne, p_imagetwo: placeImageTwo, p_imagethree: placeImageThree, p_rating: placeRating, p_description: placeDescription, p_latitude: placeLatitude, p_longitude: placeLongitude)
                    self.placeData.append(placeData)
                }
                let data = City(c_name: cityName, c_imageone: cityImageOne, c_imagetwo: cityImageTwo, c_imagethree: cityImageThree, places: self.placeData)
                self.cityData = data
            }
            
            if array.count > 0 {
                DispatchQueue.main.async { [self] in
                    self.cityNameLabel.text = self.cityData?.cityName
                }
                var urls = [self.cityData?.cityImageOne!, self.cityData?.cityImageTwo!, self.cityData?.cityImageThree!]
                self.displayImage(flag: 0, imageURLs: urls) { imgarray in
                    DispatchQueue.main.async {
                        self.sliderCollectionView.reloadData()
                        if imgarray.count > 0 {
                            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                        }
                    }
                }
                
                var placeArray = self.cityData?.places!
                self.placeData = placeArray!
                DispatchQueue.main.async {
                    self.placeCollectionView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    func displayImage(flag: Int, imageURLs: [String?], imageData: @escaping imageData)  {
        
        for each in imageURLs {
            guard let url = URL(string: each!) else {
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    if flag == 0 {
                        self.imageArray.append(image)
                        imageData(self.imageArray)
                    } else if flag == 1 {
                        self.placeimageArray.append(image)
                        imageData(self.placeimageArray)
                    }
                }
            }.resume()
            
        }
    }
}

extension ExploreCityViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return imageArray.count
        } else {
            return placeData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "citycell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                if imageArray.count > 0 {
                    vc.image = imageArray[indexPath.row]
                }
                else {
                    print("No images")
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as! PlaceCollectionViewCell
            cell.placeLabel.text = placeData[indexPath.row].placeName
            cell.placeImage.downloadImage(urlString: placeData[indexPath.row].placeImageOne!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
            vc.selectedPlace = placeData[indexPath.row]
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            let size = sliderCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        } else {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (placeCollectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: size)
        }
    }
}

/* place 1 - Rancho San Antonio County Park
 place 2 - Ridge Vineyards
 place 3 - Apple Park Visitor Center
 place 4 - Stevens Creek County Park
 place 5 - Cupertino Memorial Park
 place 6 - Apple Infinite Loop
 place 7 - Bowlmor Lanes
 place 8 - Aloft Sunnyvale (Hotel)
 place 9 - Hilton Garden Inn Cupertino (Hotel)
 place 10 - Corporate Inn Sunnyvale (Hotel)
 */
