//
//  EventTableViewCell.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 16.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    func tuneCell(with ownerImageUrl: String, ownerName: String, eventName: String) {
        ownerImageView.loadImageUsingCache(with: ownerImageUrl)
        ownerNameLabel.text = ownerName
        eventNameLabel.text = eventName
        self.backgroundColor = .clear
    }
}
