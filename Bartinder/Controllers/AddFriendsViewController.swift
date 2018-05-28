//
//  AddFriendsViewController.swift
//  Bartinder
//
//  Created by Audwin on 22/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import UIKit

class AddFriendsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friends: [FriendModel]
    var addedFriends: [FriendModel] = []
    var tableView = UITableView()
    
    init() {
        // pre-defined friends
        friends = [FriendModel(id: "6", name: "Alice"),
                   FriendModel(id: "7", name: "Ben"),
                   FriendModel(id: "8", name: "Charles"),
                   FriendModel(id: "9", name: "Diana"),
                   FriendModel(id: "10", name: "Erika")]
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        friends = []
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func setupView() {
        self.title = "Add Friends"
        
        // sort friends name alphabetically
        friends.sort(by: { $0.name < $1.name })
        
        // tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        
        let cell = UITableViewCell()
        cell.textLabel?.text = friend.name
        cell.imageView?.image = UIImage(named: "Contact")
        
        // set button
        let cellAddButton = UIButton(type: .custom)
        cellAddButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        cellAddButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        cellAddButton.setTitle("Add", for: .normal)
        cellAddButton.backgroundColor = UIColor.lightGray
        cellAddButton.layer.cornerRadius = 5
        cellAddButton.contentMode = .scaleAspectFit
        cellAddButton.tag = indexPath.row
        cell.accessoryView = cellAddButton as UIView
        
        return cell
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        let selectedFriend = friends[sender.tag]
        
        // cancel adding friend
        if sender.title(for: .normal) == "Added" {
            sender.setTitle("Add", for: .normal)
            
            // remove from the added friends list
            if let index = addedFriends.index(where: { $0.id == selectedFriend.id}) {
                addedFriends.remove(at: index)
            }
        }
        else {
            sender.setTitle("Added", for: .normal)
            addedFriends.append(selectedFriend)
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        let friend = friends[indexPath.row]
//        //get the friend's favourite drink
//        navigationController?.pushViewController(DrinkDetailViewController(drink: drink), animated: true)
//    }
    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        print("tapped \(indexPath.row)")
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // sort added friends name alphabetically
        addedFriends.sort(by: { $0.name < $1.name })
        
        // for debugging
        print("Will be adding: ")
        for addedFriend in addedFriends {
            print("+ \(addedFriend.name)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
