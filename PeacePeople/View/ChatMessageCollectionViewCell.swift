//
//  ChatMessageCollectionViewCell.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 15.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class ChatMessageCollectionViewCell: UICollectionViewCell {
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.textColor = .white
        return textView
    }()
    
    static let blueColor = UIColor(red: 0, green: 137, blue: 249, alpha: 1)
    
    let bubleView:UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    
    var bubleWidthAnchor: NSLayoutConstraint?
    var bubleViewRightAnchor: NSLayoutConstraint?
    var bubleViewLeftAnchor: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubleViewRightAnchor = bubleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        bubleViewLeftAnchor = bubleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubleViewRightAnchor?.isActive = true
        bubleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubleWidthAnchor = bubleView.widthAnchor.constraint(equalToConstant: 200)
        bubleWidthAnchor?.isActive = true
        bubleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubleViewLeftAnchor?.isActive = false
        
        textView.leftAnchor.constraint(equalTo: bubleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
