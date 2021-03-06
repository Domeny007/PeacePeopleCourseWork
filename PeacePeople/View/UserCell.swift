//
//  UserCell.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 10.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase
@objcMembers
class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            if let seconds = message?.timestamp {
                
                let timeStampDate = Date(timeIntervalSinceReferenceDate: Double(seconds)!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                
                timeLabel.text = dateFormatter.string(for: timeStampDate)
            }
        }
    }
    
    private func setupNameAndProfileImage() {

        if let id = message?.chatPartnerId() {
            let refrence = Database.database().reference().child("users").child(id)
            refrence.observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any] {
                    self.textLabel?.text = dictionary["name"] as? String
                    guard let profileImageUrl = dictionary["profileimageUrl"] as? String else { return }
                    self.profileImageView.loadImageUsingCache(with: profileImageUrl )
                }
                
            }, withCancel: nil)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 64, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)

    }
    
     let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
     let timeLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
