//
//  GeneralEventThemesCollectionViewCell.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 15.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class GeneralEventThemesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var generalEventLabel: UILabel!
    
    var generalEventName: String? {
        didSet {
            guard let generalImageName = generalEventName else { return }
            generalEventLabel.text = generalImageName
        }
    }
    

}
