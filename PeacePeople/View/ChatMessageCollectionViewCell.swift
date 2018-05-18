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
    
    let bubleView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137, blue: 249, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubleView)
        addSubview(textView)
        
        bubleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bubleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bubleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
