//
//  GeneralEventsViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 15.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase

class GeneralEventsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let generalEventThemes = ["Свадьба", "Ветераны", "Пожилые люди","Близкие","Друзья","Соседи","Животные"]
    var screenWidth = UIScreen.main.bounds.width
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageOnBackground()
        collectionView?.alwaysBounceVertical = true
    }
    
    func setImageOnBackground() {
        let backgroundImage =  UIColor(patternImage: UIImage(named: backgroundImageString)!)
        navigationBar.backgroundColor? = .clear
        self.view.backgroundColor = backgroundImage
        collectionView.backgroundColor = .clear
    }
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
        } catch let logoutError {
            print(logoutError)
            
        }
        let registrationController = UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: "registrationViewController")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate?.window?.rootViewController = registrationController
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return generalEventThemes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: generalEventCellIdentifier, for: indexPath) as!GeneralEventThemesCollectionViewCell
        cell.backgroundColor = .clear
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.darkGray.cgColor
        let generalEventName = generalEventThemes[indexPath.row]
        cell.generalEventName = generalEventName
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        
        let itemWidth = (collectionViewWidth - 2.0) / 2.0
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 1
        }
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let eventsViewController = UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: eventsVCIdentifier) as! EventsViewController
        let generalTheme = generalEventThemes[indexPath.row]
        eventsViewController.generalEventTheme = generalTheme
        present(eventsViewController, animated: true, completion: nil)
    }
}
