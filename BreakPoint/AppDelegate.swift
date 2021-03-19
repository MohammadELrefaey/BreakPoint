//
//  AppDelegate.swift
//  BreakPoint
//
//  Created by Mohamed on 1/19/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

    
// Swift
//
// AppDelegate.swift
import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//      // ...
//      if let error = error {
//        print(error)
//        return
//      }
//
//      guard let authentication = user.authentication else { return }
//      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//      Auth.auth().signIn(with: credential, completion: { (user, error) in
//           guard let user = user?.user else {
//               return
//           }
//           let userData = ["provider": user.providerID, "email": user.email]
//           DataService.instance.createUser(uid: user.uid, userData: userData)
//      })
//    }

    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
        setRootVC()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
          
    func application(_ app: UIApplication, open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool { ApplicationDelegate.shared.application(app,open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return GIDSignIn.sharedInstance().handle(url)
    }

}
    



//MARK:- Private Methods
extension AppDelegate {
    private func setRootVC() {
        if Auth.auth().currentUser == nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let rootVC = storyBoard.instantiateViewController(withIdentifier: "AuthVC")
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(rootVC, animated: false, completion: nil)
        }
    }
}
    
