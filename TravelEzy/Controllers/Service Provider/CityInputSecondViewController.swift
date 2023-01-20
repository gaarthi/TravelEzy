//
//  CityInputSecondViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 17/03/22.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos

class CityInputSecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var placeNameTF: UITextField!
    @IBOutlet weak var placeImageOne: UIImageView!
    @IBOutlet weak var placeImageTwo: UIImageView!
    @IBOutlet weak var placeImageThree: UIImageView!
    @IBOutlet weak var ratingTF: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    
    var imagePicker = UIImagePickerController()
    var placeImageURLOne: String = ""
    var placeImageURLTwo: String = ""
    var placeImageURLThree: String = ""
    typealias completionHandler = ((String?) -> Void)
    var assetName: String?
    var selectedImageView: String?
    var imageView: UIImageView?
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let ref = Database.database().reference(withPath: "Cities")
    var savedData: [String] = []
    var childRef = DatabaseReference()
    var places = DatabaseReference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childRef = ref.child(savedData[0]).childByAutoId()
        places = childRef.child("Places")
        saveEnteredCityDetails()
    }
    
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            self.selectedImageView = "ImageViewOne"
            self.imageView = placeImageOne
        } else if sender.tag == 2 {
            self.selectedImageView = "ImageViewTwo"
            self.imageView = placeImageTwo
        } else if sender.tag == 3 {
            self.selectedImageView = "ImageViewThree"
            self.imageView = placeImageThree
        }
        handleImageToUpload()
    }
    
    func handleImageToUpload() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImageFromGallery = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            switch selectedImageView {
            case "ImageViewOne":
                placeImageOne.image = selectedImageFromGallery
            case "ImageViewTwo":
                placeImageTwo.image = selectedImageFromGallery
            case "ImageViewThree":
                placeImageThree.image = selectedImageFromGallery
            default:
                print("default")
            }
        }
        
        if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset")] as? PHAsset {
            let assetResources = PHAssetResource.assetResources(for: asset)
            assetName = assetResources.first?.originalFilename
            guard let name = assetName else {
                return
            }
        }
        dismiss(animated: true, completion: nil)
        self.getImageURL { url in
            self.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if url != nil {
                switch self.selectedImageView {
                case "ImageViewOne":
                    self.placeImageURLOne = url!
                case "ImageViewTwo":
                    self.placeImageURLTwo = url!
                case "ImageViewThree":
                    self.placeImageURLThree = url!
                default:
                    print("default")
                }
                
            }
        }
    }
    
    
    func getImageURL(urlData: @escaping completionHandler) {
        self.startAnimating()
        self.view.isUserInteractionEnabled = false
        let storageRef = Storage.storage().reference().child("\(assetName!)")
        
        guard let imageView = imageView else {
            return
        }
        
        if let uploadData = imageView.image!.pngData() {
            
            storageRef.putData(uploadData, metadata: nil) { metaData, error in
                if error == nil {
                    print("Image uploaded")
                    storageRef.downloadURL { url, error in
                        guard let url = url, error == nil else {
                            return
                        }
                        let urlString = url.absoluteString
                        urlData(urlString)
                        print("Download url: \(urlString)")
                    }
                } else {
                    print("Getting error while uploading image data")
                }
            }
        }
    }
    
    func startAnimating() {
        myActivityIndicator.center = self.view.center
        self.view.addSubview(myActivityIndicator)
        self.myActivityIndicator.isHidden = false
        self.myActivityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        self.myActivityIndicator.stopAnimating()
        self.myActivityIndicator.hidesWhenStopped = true
    }
    
    
    @IBAction func addNextPlaceBtnTapped(_ sender: Any) {
        saveEnteredPlaceDetails()
        clearPlaceInputs()
    }
    
    func saveEnteredCityDetails() {
        let nameRef = childRef.child("City Name")
        let imageOneRef = childRef.child("ImageURLOne")
        let imageTwoRef = childRef.child("ImageURLTwo")
        let imageThreeRef = childRef.child("ImageURLThree")
        
        
        nameRef.setValue(savedData[0])
        imageOneRef.setValue(savedData[1])
        imageTwoRef.setValue(savedData[2])
        imageThreeRef.setValue(savedData[3])
    }
    
    func saveEnteredPlaceDetails() {
        let placeRef = places.childByAutoId()
        let placenameRef = placeRef.child("Place Name")
        let placeimageOneRef = placeRef.child("Place ImageURLOne")
        let placeimageTwoRef = placeRef.child("Place ImageURLTwo")
        let placeimageThreeRef = placeRef.child("Place ImageURLThree")
        let ratingRef = placeRef.child("Rating")
        let descriptionRef = placeRef.child("Description")
        let latitudeRef = placeRef.child("Latitude")
        let longitudeRef = placeRef.child("Longitude")
        
        placenameRef.setValue(placeNameTF.text)
        placeimageOneRef.setValue(placeImageURLOne)
        placeimageTwoRef.setValue(placeImageURLTwo)
        placeimageThreeRef.setValue(placeImageURLThree)
        ratingRef.setValue(ratingTF.text)
        descriptionRef.setValue(descriptionTextView.text)
        latitudeRef.setValue(latitudeTF.text)
        longitudeRef.setValue(longitudeTF.text)
    }
    
    func clearPlaceInputs() {
        var placeArray = [placeNameTF.text!, ratingTF.text!, placeImageURLOne, placeImageURLTwo, placeImageURLThree, descriptionTextView.text!, latitudeTF.text!, longitudeTF.text!]
        placeNameTF.text = ""
        ratingTF.text = ""
        descriptionTextView.text = ""
        latitudeTF.text = ""
        longitudeTF.text = ""
        placeImageOne.image = nil
        placeImageTwo.image = nil
        placeImageThree.image = nil
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        saveEnteredPlaceDetails()
        clearPlaceInputs()
    }
    
    func saveToFirebase() {
        let childRef = self.ref.child(savedData[0])
        let nameRef = childRef.child("City Name")
        let imageOneRef = childRef.child("ImageURLOne")
        let imageTwoRef = childRef.child("ImageURLTwo")
        let imageThreeRef = childRef.child("ImageURLThree")
        
        
        nameRef.setValue(savedData[0])
        imageOneRef.setValue(savedData[1])
        imageTwoRef.setValue(savedData[2])
        imageThreeRef.setValue(savedData[3])
        
        let places = childRef.child("Places")
        let placeRef = places.childByAutoId()
        let placenameRef = placeRef.child("Place Name")
        let placeimageOneRef = placeRef.child("Place ImageURLOne")
        let placeimageTwoRef = placeRef.child("Place ImageURLTwo")
        let placeimageThreeRef = placeRef.child("Place ImageURLThree")
        let ratingRef = placeRef.child("Rating")
        let descriptionRef = placeRef.child("Description")
        let latitudeRef = placeRef.child("Latitude")
        let longitudeRef = placeRef.child("Longitude")
        
        placenameRef.setValue(placeNameTF.text)
        placeimageOneRef.setValue(placeImageURLOne)
        placeimageTwoRef.setValue(placeImageURLTwo)
        placeimageThreeRef.setValue(placeImageURLThree)
        ratingRef.setValue(ratingTF.text)
        descriptionRef.setValue(descriptionTextView.text)
        latitudeRef.setValue(latitudeTF.text)
        longitudeRef.setValue(longitudeTF.text)
        
        print("Saved to firebase")
    }
    
}
