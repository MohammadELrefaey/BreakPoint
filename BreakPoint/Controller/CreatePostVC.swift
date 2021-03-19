//
//  CreatePostVC.swift
//  BreakPoint
//
//  Created by Mohamed on 2/3/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    //MARK:- App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLabel.text = Auth.auth().currentUser?.email
    }
    //MARK:- Actions
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if textView.text != nil && textView.text != "Say something here..." {
                self.sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (isComplete) in
                if isComplete {
                    self.sendBtn.isEnabled = true
                self.dismissDetail()
                }
                else {
                    self.sendBtn.isEnabled = true
                    print("There is Error")
                }
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        dismissDetail()
    }
}

//MARK:- TextViewDelegate Extension
extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
