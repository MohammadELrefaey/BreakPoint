//
//  FeedVC.swift
//  BreakPoint
//
//  Created by Mohamed on 1/26/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController {
    //MARK:- Properties
    var messagesArray = [Message]()
    
    //MARK:- Outlets
    @IBOutlet weak var feedTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.delegate = self
        feedTable.dataSource = self
    }
    //MARK:- App Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllFeedMessages()
        
    }
}

//MARK:- TableView Delegat & DataSource
extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        
        let message = messagesArray[indexPath.row]
         let image = UIImage(named: "defaultProfileImage")
            //getImagefor(uid: message.senderID)
        DataService.instance.getUserName(forUID: message.senderID) { (returnedUserName) in
            cell.configure(profileImage: image!, email: returnedUserName, content: message.content)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}

//MARK:- Private Mesthods
extension FeedVC {
    private func getAllFeedMessages() {
        DataService.instance.REF_FEED.observe(.value) { (snapShot) in
            DataService.instance.getAllFeedMessages(handler: { (returnedMessages) in
            self.messagesArray = returnedMessages.reversed()
            self.feedTable.reloadData()
            })
        }
    }
    
    private func getImagefor(uid: String) -> UIImage {
        var image: UIImage!
        DataService.instance.getImage(forUID: uid) { (imageString) in
        if let imageString = imageString {
           let decodedData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)
            let returnedImage = UIImage(data: decodedData!)
            image = returnedImage
        } else {
            image = UIImage(named: "defaultProfileImage")
            }
        }
        
        return image!
    }
}
