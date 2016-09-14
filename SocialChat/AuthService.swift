//
//  AuthService.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/10/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (String?, AnyObject?) -> Void


class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService{
        return _instance
    }
    
    func login(email: String, password: String, onCompelte: Completion?){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errorCode == .errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil{
                                self.handleFirebaseError(error: error!, onComplete: onCompelte)
                            } else {
                                if user?.uid != nil {
                                    //Sign in
                                    DataService.instance.saveUser(uid: user!.uid)
                                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil{
                                            //Show error to user
                                            self.handleFirebaseError(error: error!, onComplete: onCompelte)
                                        } else {
                                            //Successfully Login
                                            onCompelte?(nil, user)
                                        }
                                    })
                                }
                            }
                        })
                    }
                } else {
                    // handle all other errors
                    self.handleFirebaseError(error: error!, onComplete: onCompelte)
                }
            } else {
                //successfully logged in
                onCompelte?(nil,user)
            }
        })
    }
    
    func handleFirebaseError(error:Error, onComplete:Completion?){
        print(error.localizedDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error._code){
            switch(errorCode) {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                break
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
                break
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use.", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again", nil)
                
            }
        }
    }
    
}
