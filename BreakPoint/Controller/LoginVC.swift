//
//  LoginVC.swift
//  BreakPoint
//
//  Created by Mohamed on 1/26/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    var imageString: String?

//MARK:- Outlets
    @IBOutlet weak var emailTxtField: InsetTextField!
    @IBOutlet weak var passwordTxtField: InsetTextField!
    @IBOutlet weak var profileImg: UIImageView!
    
//MARK:- App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageGesture()
    }
    
//MARK:- Actions
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        dismissDetail()
    }
    
    @IBAction func addPhotoBtnPressed(_ sender: UIButton) {
        showImagePickerController()
    }
    
}
    //MARK:- PRIVATE METHODS
extension LoginVC {

    func goToHome() {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = Storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        presentDetail(homeVC)
    }
    
    private func imageToString(image: UIImage?) {
        guard let myimageString = image?.jpegData(compressionQuality: 1)!.base64EncodedString() else { return }
        imageString = myimageString
    }
    
    private func signIn() {
        if emailTxtField.text != nil && passwordTxtField.text != nil {
            AuthService.instance.loginUser(withEmail: emailTxtField.text!, andPassword: passwordTxtField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.goToHome()
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, image: self.imageString, userCreationComplete: { (success, registrationError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, loginComplete: { (success, nil) in
                            self.goToHome()
                            print("Successfully registered user")
                        })
                    } else {
                        print(String(describing: registrationError?.localizedDescription))
                    }
                })
            })
        }
    }
    
    private func profileImageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileImgTapped))
        profileImg.addGestureRecognizer(tap)
        profileImg.isUserInteractionEnabled = true
    }
    
    @objc func profileImgTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            showImagePickerController()
        }
    }
}

//MARK:- Image Picker Extension
extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImg.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImg.image = originalImage
        }
        imageToString(image: profileImg.image)
        dismiss(animated: true, completion: nil)
    }
    
}
