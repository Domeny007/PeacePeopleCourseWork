//
//  MessangerViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 23.04.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase

class MessengerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageOnBackground()
        tableView.register(UserCell.self, forCellReuseIdentifier: messengerCellIdentifier)
        setupRightMessages()
    }
    
    func setupRightMessages() {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
    }

    @IBAction func newMessageButtonTapped(_ sender: UIButton) {
        let newMessageViewController = UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: "newMessageVC")
        present(newMessageViewController, animated: true, completion: nil)
    }
    
    func setImageOnBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: backgroundImageString)!)
        tableView.backgroundColor = .clear
         tableView.backgroundColor = .clear
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
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }, withCancel: nil)
            }, withCancel: nil)
    }
    
    //    MARK: - tableview Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messengerCellIdentifier, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
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
