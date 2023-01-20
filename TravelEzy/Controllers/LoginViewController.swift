//
//  LoginViewController.swift
//  TravelEzy
//
//  Created by Aarthi on 18/01/22.
//

import UIKit
import SwiftyGif
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBgView: UIView!
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var getStartedLabel: UILabel!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var continueAsGuestBtn: UIButton!
    @IBOutlet weak var passwordImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProcess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            let gif = try UIImage(gifName: "Travel.gif")
            self.gifImage.setGifImage(gif, loopCount: -1)
            self.gifImage.alpha = 1.5
        } catch {
        }
        loadWelcomeView()
    }
    
    func loadWelcomeView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomePopupViewController") as! WelcomePopupViewController
        vc.modalPresentationStyle = .custom
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        vc.view.isOpaque = false
        self.present(vc, animated: true, completion: nil)
    }
    
    func initProcess() {
        loginBtn.titleLabel?.font = Theme.Font.black?.withSize(18)
        continueAsGuestBtn.titleLabel?.font = Theme.Font.black?.withSize(18)
        
        userNameTF.showBottomBorderForTF(textfield: userNameTF)
        userNameTF.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
        let image = UIImage(named: "email")
        imageView.image = image
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageContainerView.addSubview(imageView)
        userNameTF.leftView = imageContainerView
        
        passwordTF.showBottomBorderForTF(textfield: passwordTF)
        passwordTF.leftViewMode = .always
        let leftImageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
        let leftImage = UIImage(named: "password")
        leftImageView.image = leftImage
        let leftImageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftImageContainerView.addSubview(leftImageView)
        passwordTF.leftView = leftImageContainerView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        passwordImage.addGestureRecognizer(tapGesture)
        passwordImage.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
        if (gesture.view as? UIImageView) != nil {
            guard passwordImage.image == UIImage(named: "eyeview") else {
                return passwordImage.image = UIImage(named: "eyeview")
            }
            passwordImage.image = UIImage(named: "eyehidden")
        }
    }
    
    @IBAction func continueAsGuest(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CitySelectionViewController") as! CitySelectionViewController
        vc.height = 400
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        //Navigate to Service Provider View only for providing input values
        //self.performSegue(withIdentifier: "serviceProviderSegue", sender: self)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
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
