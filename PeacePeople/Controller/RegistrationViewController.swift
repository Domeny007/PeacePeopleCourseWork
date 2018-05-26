//
//  RegistrationViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 15.04.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    var messengerViewController: MessengerViewController?
    var harrisonWorkViewController: HarrisonWorkViewController?
    
    
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHightAnchor: NSLayoutConstraint?
    var emailTextFieldHightAnchor: NSLayoutConstraint?
    var passwordTextFieldHightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContainerViewHeightAndNameFieldAnchor()
        setCornersOnViewAndButton()
        setImageOnBackground()
        prepareProfileImageView()
        disableKeyboardByTouchingAnywhere()
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserLoggedIn()
        
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            initiateMainTabBarController()
        }
    }
    
    
    func disableKeyboardByTouchingAnywhere() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTouchUpSide))
        view.addGestureRecognizer(tap)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 70
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height - 70
            }
        }
    }
    
    @objc func handleTouchUpSide() {
        view.endEditing(true)
    }
    
    //    MARK: - registration button configuration
    
    func prepareProfileImageView() {
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                print(error as Any)
                return
            } else {
                self.initiateMainTabBarController()
            }
        }
    }

    //    MARK: set Height and anchor
    func setUpContainerViewHeightAndNameFieldAnchor() {
        
        nameTextFieldHightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHightAnchor?.isActive = true
        
        emailTextFieldHightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHightAnchor?.isActive = true
        
        passwordTextFieldHightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHightAnchor?.isActive = true
        
    }
    
    //    MARK: set image on controllers background
    func setImageOnBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: backgroundImageString)!)
    }
    
    //    MARK: - set corners to registor button and view
    func setCornersOnViewAndButton() {
        registrationView.layer.cornerRadius = 5
        registrationView.layer.masksToBounds = true
        loginRegisterButton.layer.cornerRadius = 5
        loginRegisterButton.layer.masksToBounds = true
    }
    
    //    MARK: segmented control configuration
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 122 : 184

        
        nameTextFieldHightAnchor?.isActive = false
        nameTextFieldHightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 0 : 1 / 3)
        nameTextFieldHightAnchor?.isActive = true
        
        emailTextFieldHightAnchor?.isActive = false
        emailTextFieldHightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 1 / 2 : 1 / 3)
        emailTextFieldHightAnchor?.isActive = true
        
        passwordTextFieldHightAnchor?.isActive = false
        passwordTextFieldHightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 1 / 2 : 1 / 3)
        passwordTextFieldHightAnchor?.isActive = true
    }
    
    
}
