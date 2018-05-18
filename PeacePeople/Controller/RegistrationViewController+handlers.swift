//
//  RegistrationViewController+handlers.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 10.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //    MARK: - Operation when register button tapped
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text  else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {return}
            let imageName = NSUUID().uuidString
            guard let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) else { return }
            let storageRefrence = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            storageRefrence.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                storageRefrence.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    let profileImageUrl = url?.absoluteString
                    let carmaNumber: NSNumber = 0
                    let eventsNumber: NSNumber = 0
                    
                    let values = ["name" : name, "email" : email, "profileimageUrl" : profileImageUrl as Any, "carmaNumber" : carmaNumber, "eventsNumber" : eventsNumber, "id" : uid] as [String : AnyObject]
                    self.registerUserInfoDatabaseWithUID(uid: uid, values: values)
                })
            })
        }
    }
    
    private func registerUserInfoDatabaseWithUID(uid: String, values: [String: Any]) {
        let refrence = Database.database().reference()
        let usersRefrence = refrence.child("users").child(uid)
        usersRefrence.updateChildValues(values, withCompletionBlock: { (error, _) in
            if error != nil {
                print(error!)
                return
            }
            
            self.initiateMainTabBarController()
            self.messengerViewController?.messengerLabel.text = values["name"] as? String
            
        })
    }
    
    func initiateMainTabBarController() {
        let mainTabBarController = UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: tabBarIdentifier)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = mainTabBarController
        
    }
    
    //    MARK: - Operation when user selects his profile image
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        present(picker, animated: true, completion: nil)
        picker.delegate = self
        picker.allowsEditing = true
    }
    
    //    MARK: - Method shows what to do if imagePickerController was cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     dismiss(animated: true, completion: nil)
    }
    
    //    MARK: - Method shows what to do after profile image was selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[infoKeyForEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[infoKeyForOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func initiateTabBarController() {
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: tabBarIdentifier) as? UITabBarController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = tabBarController
    }
    
}
