//
//  ChatLogViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 13.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var chatLogLabel: UILabel!
    @IBOutlet weak var inputMessageTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User?
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: collectionVCCellIdentifier)
        disableKeyboardByTouchingAnywhere()
        setImageOnBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        chatLogLabel.text = user?.name
        observeMessages()
    }
    func setImageOnBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: backgroundImageString)!)
        collectionView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        navigationView.backgroundColor = .clear
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userMessagesRefrence = Database.database().reference().child("user-messages").child(uid)
        userMessagesRefrence.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRefrence = Database.database().reference().child("messages").child(messageId)
            messagesRefrence.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let message = Message()
                message.setValuesForKeys(dictionary)
                if message.chatPartnerId() == self.user?.id {
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }

    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        let refrence = Database.database().reference().child("messages")
        let childRefrence = refrence.childByAutoId()
        guard let messageText = inputMessageTextField.text,
              let toUserId = user?.id,
              let fromUserId = Auth.auth().currentUser?.uid
            else { return }
        let timestamp = String(NSDate.timeIntervalSinceReferenceDate)
        
        let values = ["text" : messageText, "fromUser": fromUserId, "toUser" : toUserId, "timestamp": timestamp] as [String : Any]
        
        childRefrence.updateChildValues(values) { (error, refrence) in
            if error != nil {
                print(error as Any)
                return
            }
            self.inputMessageTextField.text = nil
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromUserId)
            let messagesId = childRefrence.key
            userMessagesRef.updateChildValues([messagesId: 1 ])
            
            let recepientUserRefrence = Database.database().reference().child("user-messages").child(toUserId)
            recepientUserRefrence.updateChildValues([messagesId: 1 ])
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        let mainTabBar = UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: tabBarIdentifier)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = mainTabBar
    }
    private func estimateFrame(for text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16) ], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionVCCellIdentifier, for: indexPath) as! ChatMessageCollectionViewCell
        let message = messages[indexPath.item]
        cell.isUserInteractionEnabled = false
        cell.textView.text = message.text
        setupCell(with: message, and: cell)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].text {
            height = estimateFrame(for: text).height + 30
        }
         return CGSize(width: view.frame.width, height: height)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func disableKeyboardByTouchingAnywhere() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTouchUpSide))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTouchUpSide() {
        view.endEditing(true)
    }
    
    func setupCell(with message: Message, and cell : ChatMessageCollectionViewCell) {
        if let profileImageUrl = self.user?.profileimageUrl{
            cell.profileImageView.loadImageUsingCache(with: profileImageUrl)
        }
        if message.fromUser == Auth.auth().currentUser?.uid {
            cell.bubleView.backgroundColor = UIColor.purple
            cell.bubleView.alpha = 0.3
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = true
            cell.bubleViewRightAnchor?.isActive = true
            cell.bubleViewLeftAnchor?.isActive = false
        } else {
            cell.bubleView.backgroundColor = UIColor.gray
            cell.bubleView.alpha = 0.3
            cell.textView.textColor = UIColor.black
            cell.bubleViewRightAnchor?.isActive = false
            cell.bubleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
    }
}
