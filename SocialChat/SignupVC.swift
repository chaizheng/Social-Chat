//
//  SignupVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 30/09/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import FirebaseStorage

class SignupVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var didchangeimage = false
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var phoneField: UITextField!
    
    private var _email:String!
    private var _password:String!
    
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage?
    
    func setEmail(email:String){
        _email = email
    }
    
    func setPass(pass:String){
        _password = pass
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastnameField.delegate = self
        firstnameField.delegate = self
        usernameField.delegate = self
        phoneField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignupVC.selectPhoto(tap:)))
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         scrollView.setContentOffset(CGPoint.init(x: 0, y: 200), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func selectPhoto(tap: UITapGestureRecognizer){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            self.imagePicker.sourceType = .photoLibrary
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func signupBtnPressed(_ sender: AnyObject) {
        if let firstName = firstnameField.text, let lastName = lastnameField.text, let username = usernameField.text, let phoneNumber = phoneField.text,(firstName.characters.count > 0 && lastName.characters.count > 0 && username.characters.count > 0 && phoneNumber.characters.count > 0 ) {
            
            if !RegEx.isValidPhone(testStr: phoneNumber){
                let alert = UIAlertController(title: "Invalid Phone Number", message: "You must enter vaild Australia 10 digits phone number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            if didchangeimage == false {
                let alert = UIAlertController(title: "Invalid profile photo", message: "You must upload your profile photo", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
            } else{
                
                var data = Data()
                data = UIImageJPEGRepresentation(profileImage.image!, 0.1)!
                
                AuthService.instance.signup(email: _email, password: _password, firstName: firstName, lastName: lastName, username: username, phoneNumber: phoneNumber, data: data, onCompelte: { (errMsg, data) in
                    guard errMsg == nil else {
                        let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.login()
                    self.dismiss(animated: false, completion: nil)
                })

            }
            
        } else {
            let alert = UIAlertController(title: "Invalid Information", message: "You must enter username, password or phone number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
}

extension SignupVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.profileImage.image = selectedPhoto
        didchangeimage = true
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

