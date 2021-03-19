//
//  GroupFeedVC.swift
//  BreakPoint
//
//  Created by Mohamed on 3/6/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    //MARK:- Properties
    var group: Group?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    //MARK:- App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        getEmails()
        getAllFeedMessages()
    }
    
    //MARK:- Actions
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendBtn.isEnabled = false
            uploadPost()
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
        }
}

//MARK:- TableView Delegate & DataSource
extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell() }
        let message = groupMessages[indexPath.row]
        DataService.instance.getUserName(forUID: message.senderID) { (email) in
            cell.configure(image: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
        }
        return cell
    }
}

//MARK:- Private Methods
extension GroupFeedVC {
    private func getAllFeedMessages() {
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllFeedMessagesFor(groupKey: (self.group?.key)!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()

                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1 , section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    private func getEmails() {
        DataService.instance.getEmailsfor(group: self.group!, handler: { (returnedEmails) in
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        })
    }
    
    private func uploadPost() {
        DataService.instance.uploadPost(withMessage: messageTextField.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: group?.key, uploadComplete: { (complete) in
            if complete {
                self.messageTextField.text = ""
                self.messageTextField.isEnabled = true
                self.sendBtn.isEnabled = true
            }
        })
    }
}

