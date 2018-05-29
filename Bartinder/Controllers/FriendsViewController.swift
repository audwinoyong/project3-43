//
//  FriendsViewController.swift
//  Bartinder
//
//  Created by Audwin on 21/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import UIKit

class FriendsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friends: [FriendModel]
    var tableView = UITableView()
    var friendService: FriendService!
    
    init() {
//        // pre-defined friends
//        friends = [FriendModel(id: "1", name: "Andreas"),
//                   FriendModel(id: "2", name: "Audwin"),
//                   FriendModel(id: "3", name: "Jason"),
//                   FriendModel(id: "4", name: "Raymond"),
//                   FriendModel(id: "5", name: "Steven")]
        friends = []
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        friends = []
        
        super.init(coder: aDecoder)
    }
    
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
        
        // set bar button items
        let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit,
                                              target: self,
                                              action: #selector(editButtonTapped))
        
        self.navigationItem.leftBarButtonItem = editButton

        let addButton = UIBarButtonItem.init(image: UIImage(named: "Contact Add"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(addButtonTapped))
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let friend = friends[indexPath.row]
        // get the friend's favourite drink
        navigationController?.pushViewController(FavoritesViewController(friendId: friend.id), animated: true)
    }
    
    @objc func editButtonTapped() {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    @objc func addButtonTapped() {
        navigationController?.pushViewController(AddFriendsViewController(), animated: true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
     }
     */
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 
    
    /*
     // Override to support rearranging the table view.
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//
//        _ = segue.destination as! AddFriendsViewController
//    }
    

}
