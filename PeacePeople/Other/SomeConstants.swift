//
//  SomeConstants.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 10.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase

let infoKeyForEditedImage = "UIImagePickerControllerEditedImage"
let infoKeyForOriginalImage = "UIImagePickerControllerOriginalImage"
let databaseRefrenceUrl = "https://peacepeople-394c0.firebaseio.com/"
let mainStoryboardString = "Main"

//    MARK: controllers identifiers
let messangerVCIdentifier = "messangerVC"
let chatVCIdentifier = "ChatVC"
let tabBarIdentifier = "mainTabBarController"
let eventsVCIdentifier = "EventsTVC"
let generalVCIdentifier = "generalEventsVCIdentifier"
let newEventVCIdentifier = "newEventVC"
let selectedEventVCIdentifier = "SelectedEventVC"





//    MARK: cells identifiers
let userCellIdentifier = "userscell"
let messengerCellIdentifier = "messengerCell"
let chatingCellIdentifier = "chatingCell"
let collectionVCCellIdentifier = "messageCell"
let eventsCellIdentifier = "eventsCellIdentifier"
let generalEventCellIdentifier = "generalEventCellIdentifier"

let backgroundImageString = "backgroundImage.jpg"



func showChatViewController(with user: User) {
    let chatViewController = UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: chatVCIdentifier) as? ChatLogViewController
    chatViewController?.user = user
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = chatViewController
}

func carmaToPercent(with carma: Double, maxPercent: Double, devision: Double) -> String {
    let percent = carma / devision
    if percent > maxPercent {
        return "\(maxPercent)"
    } else {
        return String(percent)
    }
}

func fetchCurrentUser(with percentLabel: UILabel, and maxPercent : Double, and devision: Double) {
    guard  let currentUserId = Auth.auth().currentUser?.uid else { return }
    let refrence = Database.database().reference().child("users").child(currentUserId)
    refrence.observe(.childAdded, with: { (snapshot) in
        if String(snapshot.key) == "carmaNumber" {
            guard let numberOfCarma = snapshot.value as? Double else { return }
            percentLabel.text = "Процент скидки: \(carmaToPercent(with: numberOfCarma, maxPercent: maxPercent, devision: devision))%"
        }
        
    }, withCancel: nil)
    
    
}




