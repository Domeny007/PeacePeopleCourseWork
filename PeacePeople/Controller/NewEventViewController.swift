//
//  NewEventViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 15.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase
class NewEventViewController: UIViewController {

    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var generalThemeLabel: UILabel!
    var generalThemeName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBordersToTextFieldAndTextView()
        setImageOnBackground()
        guard let generalThemeName = generalThemeName else { return }
        generalThemeLabel.text = "Категория: \(String(describing: generalThemeName))"
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let refrence = Database.database().reference()
        guard let generalThemeName = generalThemeName,
              let eventName = eventNameTextField.text,
              let eventDescription = eventDescriptionTextView.text else { return }
        let ownerId = Auth.auth().currentUser?.uid
        let eventId = NSUUID().uuidString
        let eventCount: NSNumber? = 0
        
        
        let values = ["eventName" : eventName, "eventDescription" : eventDescription, "ownerId" : ownerId as Any, "eventId" : eventId, "eventCount" : eventCount as Any ] as [String : AnyObject]
        
        let eventRefrence = refrence.child("events").child(generalThemeName).child(eventId)
        eventRefrence.updateChildValues(values) { (error, _) in
            if error != nil {
                print(error!)
                return
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func setImageOnBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: backgroundImageString)!)
    }
    func setBordersToTextFieldAndTextView() {
        eventNameTextField.layer.borderWidth = 1
        eventNameTextField.layer.borderColor = UIColor.darkGray.cgColor
        eventDescriptionTextView.layer.borderWidth = 1
        eventDescriptionTextView.layer.borderColor = UIColor.darkGray.cgColor
        eventDescriptionTextView.alpha = 0.5
        eventNameTextField.alpha = 0.5
    }
    
    
}
