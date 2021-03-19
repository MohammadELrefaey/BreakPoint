//
//  DataServices.swift
//  BreakPoint
//
//  Created by Mohamed on 1/19/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
class DataService {
    static let instance = DataService()
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("group")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, uploadComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content" : message, "senderID": uid])
            uploadComplete(true)
        }
        else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderID": uid])
            uploadComplete(true)
        }
    }
    
    func getUserName(forUID uid: String, handler: @escaping (_ userName: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func getEmailsfor(group: Group, handler: @escaping(_ emails: [String]) -> ()) {
        var emails = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSapshot) in
            guard let userSapshot = userSapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSapshot {
                if group.members.contains(user.key) {
                    emails.append(user.childSnapshot(forPath: "email").value as! String)
                }
            }
            handler(emails)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messages = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapShot) in
            guard let feedMessageSnapShot = feedMessageSnapShot.children.allObjects as? [DataSnapshot] else {return}
        for message in feedMessageSnapShot {
            let content = message.childSnapshot(forPath: "content").value as! String
            let senderID = message.childSnapshot(forPath: "senderID").value as! String
            let message = Message(content: content, senderID: senderID)
            messages.append(message)
        }
            handler(messages)
        }
    }
    
    func getAllFeedMessagesFor(groupKey: String, handler: @escaping (_ messages: [Message]) -> ()) {
        var messagesArray = [Message]()
        REF_GROUPS.child(groupKey).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapShot) in
            guard let groupMessageSnapShot = groupMessageSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for message in groupMessageSnapShot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderID = message.childSnapshot(forPath: "senderID").value as! String
                let message = Message(content: content, senderID: senderID)
                messagesArray.append(message)
            }
            handler(messagesArray)
        }
    }
        
    
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]?) -> () ) {
        REF_USERS.observe(.value) { (userSnapShot) in
            var emailArray = [String]()
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getUsersIDs(for usersEmails: [String], handler: @escaping(_ usersIDs: [String]) -> ()) {
        var usersIDS = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapShot) in
            guard let usersSnapShot = usersSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in usersSnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if usersEmails.contains(email) {
                    usersIDS.append(user.key)
                }
            }
            handler(usersIDS)
        }
    }
    
    func createGroup(for title: String, andDescription description: String, andUsersIDs ids: [String], handler: @escaping(_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groups: [Group]) -> ()) {
        var groups = [Group]()
       REF_GROUPS.observeSingleEvent(of: .value) { (groupsSnapShott) in
            guard let groupsSnapShott = groupsSnapShott.children.allObjects as? [DataSnapshot] else {return}
        for group in groupsSnapShott {
            let members = group.childSnapshot(forPath: "members").value as! [String]
            if members.contains(Auth.auth().currentUser!.uid) {
                let title = group.childSnapshot(forPath: "title").value as! String
                let description = group.childSnapshot(forPath: "description").value as! String
                let membersCount = members.count
                let key = group.key
                let group = Group(title: title, description: description, key: key, members: members, memberCount: membersCount)
                groups.append(group)
            }
        }
            handler(groups)
        }
    }
    
    func getImage(forUID uid: String, handler: @escaping (_ image: String?) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot {
                if user.key == uid {
                    if let image = user.childSnapshot(forPath: "image").value as? String {
                        print("image")
                        handler(image)
                    } else {
                        handler(nil)
                    }
                }
            }
        }
    }
    
    func getUser(for uid: String, handler: @escaping(_ user: User) -> ()){
        var myUser = User()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot {
                if user.key == uid {
                    myUser.image = user.childSnapshot(forPath: "image").value as? String
                    myUser.uid = uid
                    myUser.email = user.childSnapshot(forPath: "email").value as? String
                }
            }
        }
        REF_FEED.observeSingleEvent(of: .value) { (messagesSnapShot) in
            var messages = [String]()
            guard let messagesSnapShot = messagesSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for message in messagesSnapShot {
                if uid == message.childSnapshot(forPath: "senderID").value as! String {
                    messages.append(message.childSnapshot(forPath: "content").value as! String)
                }
                myUser.messages = messages
            }
        }
        print(myUser.email)
       handler(myUser)
    }
    
    func getAllFeedMessagesfor(uid: String, handler: @escaping (_ messages: [Message]) -> ()) {
        var messages = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapShot) in
            guard let feedMessageSnapShot = feedMessageSnapShot.children.allObjects as? [DataSnapshot] else {return}
        for message in feedMessageSnapShot {
            let content = message.childSnapshot(forPath: "content").value as! String
            let senderID = message.childSnapshot(forPath: "senderID").value as! String
            
            if uid == senderID {
                let message = Message(content: content, senderID: senderID)
                messages.append(message)
            }
        }
            handler(messages)
        }
    }
}
