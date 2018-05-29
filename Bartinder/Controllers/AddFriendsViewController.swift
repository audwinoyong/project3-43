//
//  AddFriendsViewController.swift
//  Bartinder
//
//  Created by Audwin on 22/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import UIKit

class AddFriendsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users: [FriendModel]
    var friends: [FriendModel] = []
    var tableView = UITableView()
    
    var friendService: FriendService!
    
    init() {
        // pre-defined friends
        users = []
//        friends = [FriendModel(id: "6", name: "Alice"),
//                   FriendModel(id: "7", name: "Ben"),
//                   FriendModel(id: "8", name: "Charles"),
//                   FriendModel(id: "9", name: "Diana"),
//                   FriendModel(id: "10", name: "Erika")]

        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        users = []
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendService = FriendService()
        if let uid = userId {
            friendService.getUsers(userId: uid, callback: { user in
                self.users.append(user)
                self.tableView.reloadData()
            })
            
            
            friendService.getFriendsFor(userId: uid, callback: { friend in
                self.friends.append(friend)
            })
        }
        
        setupView()
    }
    
    
    func setupView() {
        self.title = "Add Friends"
        
        // sort friends name alphabetically
        users.sort(by: { $0.name < $1.name })
        
        // tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        let isFriend = userIsFriend(user)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = user.name
        cell.imageView?.image = UIImage(named: "Contact")
        
        // set button
        let cellAddButton = UIButton(type: .custom)
        cellAddButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        cellAddButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        cellAddButton.setTitle(isFriend ? "Added" : "Add", for: .normal)
        cellAddButton.backgroundColor = UIColor.lightGray
        cellAddButton.layer.cornerRadius = 5
        cellAddButton.contentMode = .scaleAspectFit
        cellAddButton.tag = indexPath.row
        cell.accessoryView = cellAddButton as UIView
        
        return cell
    }
    
    func userIsFriend(_ user: FriendModel) -> Bool {
        for friend in friends {
            if friend.id == user.id {
                return true
            }
        }
        return false;
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        let selectedFriend = users[sender.tag]
        
        // cancel adding friend
        if sender.title(for: .normal) == "Added" {
            
            // remove from friends list
            if let uid = userId {
                friendService.removeFriendFor(userId: uid, friend: selectedFriend)
            }
            
            // reset button title
            sender.setTitle("Add", for: .normal)
        }
        else {
            // reset button title
            sender.setTitle("Added", for: .normal)
            
            // add friend to friend list
            if let uid = userId {
                friendService.addFriendFor(userId: uid, friend: selectedFriend)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
