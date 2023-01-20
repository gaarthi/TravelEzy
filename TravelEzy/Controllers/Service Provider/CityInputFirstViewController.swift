//
//  CityInputFirstViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 17/03/22.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos

class CityInputFirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cityNameTF: UITextField!
    @IBOutlet weak var cityImageOne: UIImageView!
    @IBOutlet weak var cityImageTwo: UIImageView!
    @IBOutlet weak var cityImageThree: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var cityImageURLOne: String = ""
    var cityImageURLTwo: String = ""
    var cityImageURLThree: String = ""
    typealias completionHandler = ((String?) -> Void)
    var assetName: String?
    var selectedImageView: String?
    var imageView: UIImageView?
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let ref = Database.database().reference(withPath: "Cities")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImagesForUpload()
    }
    
    func configureImagesForUpload() {
        cityImageOne.isUserInteractionEnabled = true
        cityImageTwo.isUserInteractionEnabled = true
        cityImageThree.isUserInteractionEnabled = true
    }
    
    func handleImageToUpload() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func uploadImageOne(_ sender: UIButton) {
        if sender.tag == 1 {
            self.selectedImageView = "ImageViewOne"
            self.imageView = cityImageOne
        } else if sender.tag == 2 {
            self.selectedImageView = "ImageViewTwo"
            self.imageView = cityImageTwo
        } else if sender.tag == 3 {
            self.selectedImageView = "ImageViewThree"
            self.imageView = cityImageThree
        }
        handleImageToUpload()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImageFromGallery = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            switch selectedImageView {
            case "ImageViewOne":
                cityImageOne.image = selectedImageFromGallery
            case "ImageViewTwo":
                cityImageTwo.image = selectedImageFromGallery
            case "ImageViewThree":
                cityImageThree.image = selectedImageFromGallery
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
                    self.cityImageURLOne = url!
                case "ImageViewTwo":
                    self.cityImageURLTwo = url!
                case "ImageViewThree":
                    self.cityImageURLThree = url!
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
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        self.navigateToNextInputScreen()
    }
    
    func saveToFirebase() {
        let childRef = self.ref.childByAutoId()
        let nameRef = childRef.child("City Name")
        let imageOneRef = childRef.child("ImageURLOne")
        let imageTwoRef = childRef.child("ImageURLTwo")
        let imageThreeRef = childRef.child("ImageURLThree")
        
        nameRef.setValue(cityNameTF.text)
        imageOneRef.setValue(cityImageURLOne)
        imageTwoRef.setValue(cityImageURLTwo)
        imageThreeRef.setValue(cityImageURLThree)
        print("Saved to firebase")
    }
    
    func navigateToNextInputScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityInputSecondViewController") as! CityInputSecondViewController
        
        vc.savedData = [self.cityNameTF.text!, self.cityImageURLOne, self.cityImageURLTwo, self.cityImageURLThree]
        self.present(vc, animated: true, completion: nil)
    }
}
