//
//  EventsViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 15.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase
class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var eventNavigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    var generalEventTheme: String?
    var events = [Event]()
    var owners = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEvents()
        setImageOnBackground()
        registerEventCell()
        checkThatUserHaveTenEvents()
        
        self.tableView.addSubview(self.refreshControl)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        eventNavigationBar.topItem?.title = generalEventTheme
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .darkGray
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        events.removeAll()
        owners.removeAll()
        fetchEvents()
        refreshControl.endRefreshing()
    }
    
    func setImageOnBackground() {
        let backgroundImage = UIColor(patternImage: UIImage(named: backgroundImageString)!)
        self.view.backgroundColor = backgroundImage
        tableView.backgroundColor = .clear
    }
    
    func registerEventCell() {
        let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: eventsCellIdentifier)
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let newEventViewController = UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: newEventVCIdentifier) as! NewEventViewController
        newEventViewController.generalThemeName = generalEventTheme
        present(newEventViewController, animated: true, completion: nil)
    }
    
    func checkThatUserHaveTenEvents() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRefrence = Database.database().reference().child("users")
        userRefrence.observe(.childAdded, with: { (snapshot) in
            if snapshot.key == userId {
            guard let dictionary = snapshot.value as? [String : Any] else { return }
                let user = User()
            user.setValuesForKeys(dictionary)
            guard let userEventsNumber = user.eventsNumber else { return }
            if Int(truncating: userEventsNumber) < 10 {
                self.createButton.tintColor = .lightGray
                self.createButton.isUserInteractionEnabled = false
            }
            }
        }, withCancel: nil)
        
        
    }
    
    func fetchEvents() {
        let refrence = Database.database().reference()
        guard let generalEventTheme = generalEventTheme else { return }
        
        refrence.child("events").child(generalEventTheme).observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let event = Event()
            self.fetchOwner(with: event)
            event.setValuesForKeys(dictionary)
            self.events.append(event)
            
            
        }, withCancel: nil)
    }
    func fetchOwner(with event: Event?) {
        
        let refrence = Database.database().reference()
        refrence.child("users").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let owner = User()
            owner.id = snapshot.key
            if event?.ownerId == owner.id {
                let owner = User()
                owner.id = snapshot.key
                owner.setValuesForKeys(dictionary)
                self.owners.append(owner)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventsCellIdentifier, for: indexPath) as! EventTableViewCell
        if owners.count == events.count && owners.count != 0 {
            let event = events[indexPath.row]
            let owner = owners[indexPath.row]
            
            cell.tuneCell(with: owner.profileimageUrl!, ownerName: owner.name!, eventName:  event.eventName!)
            return cell
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedEventViewController = UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: selectedEventVCIdentifier) as! SelectedEventViewController
        let owner = owners[indexPath.row]
        let event = events[indexPath.row]
        selectedEventViewController.event = event
        selectedEventViewController.owner = owner
        selectedEventViewController.eventsTheme = generalEventTheme
        present(selectedEventViewController, animated: true, completion: nil)
    }

}
