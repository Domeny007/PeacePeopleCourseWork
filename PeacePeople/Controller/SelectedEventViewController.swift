//
//  SelectedEventViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 16.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase
class SelectedEventViewController: UIViewController {
    
    @IBOutlet weak var messageMeButton: UIButton!
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerEmailLabel: UILabel!
    @IBOutlet weak var selectedEventTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var takePartButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var selectedEventNavigationBar: UINavigationBar!
    @IBOutlet weak var selectedEventNameTextField: UITextField!
    
    @IBOutlet weak var eventCounterLabel: UILabel!
    
    var buttonChanged: Bool = true
    var takePartButtonPressed:Bool = true
    
    
    var owner: User?
    var event: Event?
    var eventsTheme: String?
    var usersWhoTookPart = [String]()
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUsersInformation()
        setImageOnBackground()
        checkIfUserIsOwner()
        changeButton.setTitle("Изменить", for: .normal)
        checkIfUserIsParticipant()
        setAlphaForTextFieldAndTextView()
    }
    
    func deleteEvent()  {
        guard let eventId = event?.eventId, let eventTheme = eventsTheme else { return }
        let refrence = Database.database().reference().child("events").child(eventTheme).child(eventId)
        let takePartRefrence = Database.database().reference().child("takepartuser").child(eventId)
        takePartRefrence.removeValue { (error, _) in
            if error != nil {
                print(error!)
                return
            }
        }
        refrence.removeValue { (error, _) in
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
    
    func setupUsersInformation() {
        guard let ownerImageUrl = owner?.profileimageUrl,
              let ownerName = owner?.name,
              let ownerEmail = owner?.email,
              let eventName = event?.eventName,
              let eventText = event?.eventDescription else { return }
        
        ownerImageView.loadImageUsingCache(with: ownerImageUrl)
        ownerNameLabel.text = ownerName
        ownerEmailLabel.text = ownerEmail
        selectedEventTextView.text = eventText
        //selectedEventNavigationBar.topItem?.title = eventName
        selectedEventNameTextField.text = eventName
    }
    
    func checkIfUserIsOwner() {
        guard let ownerId = owner?.id, let currentUserId = Auth.auth().currentUser?.uid, let eventCount = event?.eventCount else { return }
        if ownerId == currentUserId {
            takePartButton.isHidden = true
            eventCounterLabel.text = "Количество участников: \(String(describing: eventCount)) "
            messageMeButton.isHidden = true
        } else {
            completeButton.isHidden = true
            deleteButton.isHidden = true
            changeButton.isHidden = true
        }
    }
    
    func setAlphaForTextFieldAndTextView() {
        selectedEventTextView.alpha = 0.4
        selectedEventNameTextField.alpha = 0.4
    }
    
    func checkIfUserIsParticipant()  {
        guard let eventId = event?.eventId, let currentUserId = Auth.auth().currentUser?.uid else { return }
        let refrence = Database.database().reference().child("takepartuser").child(eventId)
        refrence.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            if let _ = dictionary[currentUserId] {
                self.takePartButton.setTitle("Отменить участие", for: .normal)
                self.takePartButton.tintColor = UIColor.red
            }
        }, withCancel: nil)
    }
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        if buttonChanged {
            selectedEventNameTextField.alpha = 1
            selectedEventTextView.alpha = 1
            sender.setTitle("Готово", for: [])
            selectedEventNameTextField.isEnabled = true
            selectedEventTextView.isEditable = true
            buttonChanged = false
        } else {
            guard let eventTheme = eventsTheme,
                let eventDescription = selectedEventTextView.text,
                let newEventName = selectedEventNameTextField.text,
                let eventId = event?.eventId else { return }
            
            let refrence = Database.database().reference().child("events").child(eventTheme).child(eventId)
            let values = ["eventDescription" : eventDescription, "eventName" : newEventName] as [String : AnyObject]
            refrence.updateChildValues(values) { (error, _) in
                if error != nil {
                    print(error!)
                    return
                } else {
                    //self.selectedEventNavigationBar.topItem?.title = newEventName
                    sender.setTitle("Изменить", for: [])
                    self.selectedEventTextView.isEditable = false
                    self.selectedEventNameTextField.isEnabled = false
                    self.buttonChanged = true
                    self.setAlphaForTextFieldAndTextView()
                }
            }

        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        deleteEvent()
    }
    @IBAction func takePartButtonPressed(_ sender: UIButton) {
        guard let eventId = event?.eventId, let currentUserId = Auth.auth().currentUser?.uid, let eventCount = event?.eventCount, let eventTheme = eventsTheme else { return }
        let refrence = Database.database().reference()
        
        let currentEventRefrence = refrence.child("events").child(eventTheme).child(eventId)
        if takePartButton.tintColor != .red {
            let value = [currentUserId : currentUserId]
        
            refrence.child("takepartuser").child(eventId).updateChildValues(value) { (error, _) in
                if error != nil {
                    print(error!)
                    return
                } else {
                    self.takePartButton.setTitle("Отменить участие", for: [])
                    self.takePartButton.tintColor = .red
                    let newEventCount = Int(truncating: eventCount) + 1
                    let value = ["eventCount" : newEventCount]
                    self.event?.eventCount = NSNumber(value: newEventCount)
                    currentEventRefrence.updateChildValues(value, withCompletionBlock: { (error, _) in
                        if error != nil {
                            print(error!)
                            return
                        }
                    })
                    
                }
            }
        } else {
            refrence.child("takepartuser").child(eventId).child(currentUserId).removeValue { (error, _) in
                if error != nil {
                    print(error!)
                    return
                } else {
                    self.takePartButton.setTitle("Принять участие", for: [])
                    self.takePartButton.tintColor = UIColor(displayP3Red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1)
                    
                    let newEventCount = Int(truncating: eventCount) - 1
                    let value = ["eventCount" : newEventCount]
                    self.event?.eventCount = NSNumber(value: newEventCount)
                  
                    currentEventRefrence.updateChildValues(value, withCompletionBlock: { (error, _) in
                        if error != nil {
                            print(error!)
                            return
                        }
                    })
                }
            }
        }
        
    }
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        guard let eventId = event?.eventId else { return }
        
        let usersRefrence = Database.database().reference().child("users")
        let takepartuserRefrence = Database.database().reference().child("takepartuser").child(eventId)
        
        takepartuserRefrence.observe(.childAdded, with: { (takePartSnapshot) in
            let tookPartUserKey = takePartSnapshot.key
            self.usersWhoTookPart.append(tookPartUserKey)
        }, withCancel: nil)
        
        usersRefrence.observe(.childAdded, with: { (usersSnapshot) in
            guard let dictionary = usersSnapshot.value as? [String : AnyObject]else { return }
            let user = User()
            user.setValuesForKeys(dictionary)
            guard let userCarma = user.carmaNumber, let eventsNumber = user.eventsNumber else { return }
            for i in 0..<self.usersWhoTookPart.count {
                let eventerId = self.usersWhoTookPart[i]
                if eventerId == user.id {
                    let newUserCarma = Int(truncating: userCarma) + 10
                    let neweventsNumber = Int(truncating: eventsNumber) + 1
                    
                    let values = ["carmaNumber" : newUserCarma, "eventsNumber" : neweventsNumber ]
                    
                    usersRefrence.child(user.id!).updateChildValues(values, withCompletionBlock: { (error, _) in
                        if error != nil {
                            print(error!)
                            return
                        } else {
                            self.deleteEvent()
                        }

                    })
                }
               
            }
            if self.usersWhoTookPart.count == 0 {
                self.deleteEvent()
            }
        }, withCancel: nil)
        
    }
    @IBAction func messageMeButtonPressed(_ sender: UIButton) {
        observeUserMessages()
        for i in 0..<messages.count {
            let message = messages[i]
            if message.chatPartnerId() == owner?.id{
                guard let chatPartnerId = message.chatPartnerId() else { return }
                let refrence = Database.database().reference().child("users").child(chatPartnerId)
                refrence.observe(.value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                    
                    let user = User()
                    user.id = chatPartnerId
                    user.setValuesForKeys(dictionary)
                    showChatViewController(with: user)
                    
                }, withCancel: nil)
            }
            
        }
        if messages.count == 0 {
            let user = User()
            user.id = owner?.id
            showChatViewController(with: user)
        }
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let refrence = Database.database().reference().child("user-messages").child(uid)
        refrence.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRefrence = Database.database().reference().child("messages").child(messageId)
            messagesRefrence.observeSingleEvent(of: .value, with: { (spanshot) in
                guard let dictionary = spanshot.value as? [String : AnyObject] else { return }
                let message = Message()
                message.setValuesForKeys(dictionary)
                if let toUser = message.toUser {
                    self.messagesDictionary[toUser] = message
                    self.messages = Array(self.messagesDictionary.values)
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
