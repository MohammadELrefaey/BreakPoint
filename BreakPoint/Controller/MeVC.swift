//
//  MeVC.swift
//  BreakPoint
//
//  Created by Mohamed on 2/3/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FacebookLogin
import GoogleSignIn

class MeVC: UIViewController {
    //MARK:- Outlets
    var messagesArray = [Message]()

    //MARK:- Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emaiLabel: UILabel!
    @IBOutlet weak var tabelView: UITableView!
    
    //MARK:- App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.delegate = self
        tabelView.dataSource = self
        getAllFeedMessages()
        self.emaiLabel.text = Auth.auth().currentUser?.email
        getImage()
    }
    //MARK:- Actions
    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        let logoutAlert = UIAlertController(title: "Warning", message: "Are You Sure To Logout", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive, handler: { (buttonTapped) in
            do {
                try Auth.auth().signOut()
              let loginManager = LoginManager()
                loginManager.logOut()
                GIDSignIn.sharedInstance()?.signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
                    self.present(authVC, animated: true, completion: nil)
            } catch {
                print(error)
            }
        })
        logoutAlert.addAction(logoutAction)
        logoutAlert.addAction(cancelAction)
        present(logoutAlert, animated: true, completion: nil)
    }
}
//MARK:- TableView Delegat & DataSource
extension MeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        
        let image = UIImage(named: "defaultProfileImage")
        let message = messagesArray[indexPath.row]
        DataService.instance.getUserName(forUID: message.senderID) { (returnedUserName) in
            cell.configure(profileImage: image!, email: returnedUserName, content: message.content)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}


//MARK:- Private Methods
extension MeVC {
    private func getImage() {
        DataService.instance.getImage(forUID: Auth.auth().currentUser!.uid) { (imageString) in
        if let imageString = imageString {
           let decodedData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)
            let image = UIImage(data: decodedData!)
            self.profileImg.image = image
        }
        }
    }
    
    private func getAllFeedMessages() {
        DataService.instance.REF_FEED.observe(.value) { (snapShot) in
            DataService.instance.getAllFeedMessagesfor(uid: Auth.auth().currentUser!.uid, handler: { (returnedMessages) in
            self.messagesArray = returnedMessages.reversed()
            self.tabelView.reloadData()
            })
        }
    }
}

