//
//  RestaurantInputSecondViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 24/03/22.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos
import DropDown

class RestaurantInputSecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var itemCostTF: UITextField!
    
    var imagePicker = UIImagePickerController()
    var assetName: String?
    var imageURL: String?
    var savedData: [String] = []
    let ref = Database.database().reference(withPath: "Restaurants")
    var childRef = DatabaseReference()
    var menuItems = DatabaseReference()
    typealias completionHandler = ((String?) -> Void)
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageToUpload)))
        childRef = ref.child(savedData[0]).childByAutoId()
        menuItems = childRef.child("Menu Items")
        saveEnteredRestaurantDetails()
    }
    
    @objc func handleImageToUpload() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImageFromGallery = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            itemImageView.image = selectedImageFromGallery
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
            if url != nil {
                self.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.imageURL = url
            }
        }
    }
    
    
    func getImageURL(urlData: @escaping completionHandler) {
        
        self.startAnimating()
        self.view.isUserInteractionEnabled = false
        let storageRef = Storage.storage().reference().child("\(assetName!)")
        
        if let uploadData = itemImageView.image!.pngData() {
            
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
    
    @IBAction func addNextItemBtnTapped(_ sender: UIButton) {
        saveEnteredItemDetails()
        clearMenuItemInputs()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        saveEnteredItemDetails()
        clearMenuItemInputs()
    }
    
    func saveEnteredRestaurantDetails() {
        let nameRef = childRef.child("Name")
        let addressRef = childRef.child("Address")
        let costRef = childRef.child("Estimated Cost")
        let cuisineRef = childRef.child("Cuisine")
        let ratingRef = childRef.child("Rating")
        let numberofReviewsRef = childRef.child("Number of Reviews")
        let costTypeRef = childRef.child("Cost Type")
        let timingsRef = childRef.child("Timings")
        
        nameRef.setValue(savedData[1])
        addressRef.setValue(savedData[2])
        costRef.setValue(savedData[3])
        cuisineRef.setValue(savedData[4])
        ratingRef.setValue(savedData[5])
        numberofReviewsRef.setValue(savedData[6])
        costTypeRef.setValue(savedData[7])
        timingsRef.setValue(savedData[8])
    }
    
    func saveEnteredItemDetails() {
        
        if (imageURL != nil) && (!itemNameTF.text!.isEmpty) && (!itemCostTF.text!.isEmpty) {
            
            let itemsRef = menuItems.childByAutoId()
            let itemImageRef = itemsRef.child("Item Image")
            let itemNameRef = itemsRef.child("Item Name")
            let itemCostRef = itemsRef.child("Item Cost")
            
            itemImageRef.setValue(self.imageURL)
            itemNameRef.setValue(itemNameTF.text)
            itemCostRef.setValue(itemCostTF.text)
        }
    }
    
    func clearMenuItemInputs() {
        itemNameTF.text = ""
        itemCostTF.text = ""
        itemImageView.image = nil
    }
}
