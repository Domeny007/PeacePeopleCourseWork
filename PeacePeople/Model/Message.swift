//
//  Message.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 13.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase

@objcMembers
class Message: NSObject {
    
    var text: String?
    var fromUser: String?
    var toUser: String?
    var timestamp: String?
    
    func chatPartnerId() -> String? {
        return fromUser == Auth.auth().currentUser?.uid ? toUser : fromUser
    }
    
}
