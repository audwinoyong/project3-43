//
//  FriendsViewController.swift
//  Bartinder
//
//  Created by Audwin on 21/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import UIKit

class FriendsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var tableView = UITableView()
    
    var friends: [FriendModel]
    var friendService: FriendService!
    
    init() {
        friends = []
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        friends = []
        
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendService = FriendService()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        friends.removeAll()
        if let uid = userId {
            friendService.getFriendsFor(userId: uid, callback: { (friend) in
                self.friends.append(friend)
                self.tableView.reloadData()
            })
//            friendService.addUser(user: FriendModel(id: uid, name: "Audwin"))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        friends.removeAll()
    }
    
    func setupView() {
        // sort friends name alphabetically
        friends.sort(by: { $0.name < $1.name })
        
        // tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        
        // set bar button item
        let addButton = UIBarButtonItem.init(image: UIImage(named: "Contact Add"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(addButtonTapped))
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        
        let cell = UITableViewCell()
        cell.textLabel?.text = friend.name
        cell.imageView?.image = UIImage(named: "Contact")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let friend = friends[indexPath.row]
        // get the friend's favourite drink
        navigationController?.pushViewController(FavoritesViewController(friendId: friend.id), animated: true)
    }
    
    @objc func addButtonTapped() {
        navigationController?.pushViewController(AddFriendsViewController(), animated: true)
    }
    
}
