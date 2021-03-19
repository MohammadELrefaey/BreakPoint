//
//  AuthService.swift
//  BreakPoint
//
//  Created by Mohamed on 1/25/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//
import Foundation
import Firebase
import FacebookLogin
import GoogleSignIn

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, image: String?, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user?.user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email, "image": image]
            DataService.instance.createUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
    
    func loginWithFacebook(viewController: UIViewController, handler: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
            if let error = error {
                print("facebook error")
                handler(false, error)
                   return
               } else {
                guard let accessToken = AccessToken.current else {
                    print("Failed to get access token")
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login by calling Firebase APIs
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                     guard let user = user?.user else {
                         handler(false, error)
                         return
                     }
                     let userData = ["provider": user.providerID, "email": user.email]
                    DataService.instance.createUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
                     handler(true,nil)
                })
            }
        }
    }
    
}
