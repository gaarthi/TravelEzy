//
//  HotelInputFirstViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 11/03/22.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos
import DropDown

protocol DataDelegate {
    func sendSavedData(data: [String])
}

class HotelInputFirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var selectedRating: String?
    var ratingOptions = ["5", "4", "3", "2", "1"]
    var imagePicker = UIImagePickerController()
    var imageURL: String = ""
    var delegate: DataDelegate?
    typealias completionHandler = ((String?) -> Void)
    let ref = Database.database().reference(withPath: "Hotels")
    var assetName: String?
    var textFields : [UITextField]!
    let dropDown = DropDown()
    var selectedCity = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTF.text = ""
        addressTF.text = ""
        priceTF.text = ""
        ratingTextField.text = ""
        descriptionTextView.text = ""
        selectionImage.image = nil
    }
    
    @IBAction func selectCityBtnTapped(_ sender: UIButton) {
        dropDown.dataSource = ["Cupertino", "Chennai"]
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self?.selectedCity = item
        }
    }
    
    @IBAction func selectImageToUpload(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        self.getImageURL { url in
            if url != nil {
                self.imageURL = url!
                self.navigateToNextInputScreen()
            }
        }
    }
    
    func navigateToNextInputScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HotelInputSecondViewController") as! HotelInputSecondViewController
        vc.savedData = [selectedCity, self.nameTF.text!, self.imageURL, self.addressTF.text!, self.priceTF.text!, self.ratingTextField.text!, self.descriptionTextView.text!]
        self.present(vc, animated: true, completion: nil)
    }
    
    func saveToFirebase() {
        let childRef = self.ref.childByAutoId()
        let nameRef = childRef.child("Name")
        let imageRef = childRef.child("ImageURL")
        let addressRef = childRef.child("Address")
        let priceRef = childRef.child("Price")
        let ratingRef = childRef.child("Rating")
        let descriptionRef = childRef.child("Description")
        
        nameRef.setValue(nameTF.text)
        imageRef.setValue(imageURL)
        addressRef.setValue(addressTF.text)
        priceRef.setValue(priceTF.text)
        ratingRef.setValue(ratingTextField.text)
        descriptionRef.setValue(descriptionTextView.text)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            selectionImage.image = selectedImage
        }
        
        if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset")] as? PHAsset {
            let assetResources = PHAssetResource.assetResources(for: asset)
            assetName = assetResources.first?.originalFilename
            guard let name = assetName else {
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func getImageURL(urlData: @escaping completionHandler) {
        let storageRef = Storage.storage().reference().child("\(assetName!)")
        if let uploadData = self.selectionImage.image!.pngData() {
            
            storageRef.putData(uploadData, metadata: nil) { metaData, error in
                if error == nil {
                    print("Image uploaded")
                    storageRef.downloadURL { url, error in
                        guard let url = url, error == nil else {
                            return
                        }
                        let urlString = url.absoluteString
                        self.imageURL = urlString
                        urlData(urlString)
                        print("Download url: \(urlString)")
                    }
                } else {
                    print("Getting error while uploading image data")
                }
            }
        }
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        ratingTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        ratingTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
}

extension HotelInputFirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension HotelInputFirstViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratingOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratingOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRating = ratingOptions[row] // selected item
        ratingTextField.text = selectedRating
    }
}


