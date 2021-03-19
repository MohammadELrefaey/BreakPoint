//
//  AuthVC.swift
//  BreakPoint
//
//  Created by Mohamed on 1/26/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import GoogleSignIn

class AuthVC: UIViewController {
//MARK:- Outlets
@IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

    }
    
//MARK:- App Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismissDetail()
        }
    }
    
    
// MARK: - Actions
    @IBAction func loginWithFacebookBtnPressed(_ sender: FBLoginButton) {
        AuthService.instance.loginWithFacebook(viewController: self) { (success, error) in
            if success {
                self.goToHome()
            }
            print(error?.localizedDescription as Any)
        }
    }
    
    @IBAction func loginWithGoogleBtnPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }

     @IBAction func loginWithEmailBtnPressed(_ sender: UIButton) {
        goToLoginVC()
     }
}
// MARK: - Private methods
extension AuthVC {
    func goToLoginVC() {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = Storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        presentDetail(loginVC)
    }
    
    func goToHome() {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = Storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        presentDetail(homeVC)
    }
}

//MARK:- Google Authentication Delegate
extension AuthVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
      if let error = error {
        print(error.localizedDescription)
        return
      }
        
      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential, completion: { (user, error) in
           guard let user = user?.user else {
               return
           }
           let userData = ["provider": "Google", "email": user.email]
           DataService.instance.createUser(uid: user.uid, userData: userData)
            self.goToHome()
      })
    }
}

