//
//  ChairBarberShopViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 18.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class ChairBarberShopViewController: UIViewController {

    @IBOutlet weak var percentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser(with: percentLabel, and: 20, and: 10)
        percentLabel.textColor = .black
    }
}
