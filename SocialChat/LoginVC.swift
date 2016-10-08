//
//  LoginVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/10/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class LoginVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var emailField: RoundTextField!
    
    @IBOutlet weak var passwordField: RoundTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SignupVC{
            if let emailAndPass = sender as? [String]{
                destination.setEmail(email: emailAndPass[0])
                destination.setPass(pass: emailAndPass[1])
            }
        }
    }
    
    
    
    
    @IBAction func signupBtnPressed(_ sender: AnyObject) {
        if let email = emailField.text, let pass = passwordField.text, (self.isValidEmail(testStr: email) && pass.characters.count > 0) {
            if pass.characters.count >= 6 {
                let emailAndPass = [email,pass]
                performSegue(withIdentifier: "SignupVC", sender: emailAndPass)
            } else{
                let alert = UIAlertController(title: "Invalid Password", message: "Password length must greater than 6.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Invalid Username or Password", message: "You must enter vaild username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: AnyObject) {
        if let email = emailField.text, let pass = passwordField.text, (self.isValidEmail(testStr: email) && pass.characters.count > 0) {
            
            //Call the login service
            AuthService.instance.login(email: email, password: pass, onCompelte: { (errMsg, data) in
                guard errMsg == nil else {
                    let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                self.dismiss(animated: false, completion: nil)
                appDelegate.login()
                
            })
            
        } else {
            let alert = UIAlertController(title: "Invalid Username or Password", message: "You must enter vaild username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
   
}
