//
//  Extentions.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 10.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    
    func loadImageUsingCache(with urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = cachedImage
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                guard let downloadedImage = UIImage(data: data!) else { return }
                imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                self.image = downloadedImage
            }
            }.resume()
    }
}
