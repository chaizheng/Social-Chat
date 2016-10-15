//
//  AuthService.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/10/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

typealias Completion = (String?, AnyObject?) -> Void


var myusername: String?
var myfirstName: String?
var mylastName: String?
var myphoneNumber: String?
var myimageUrl: String?
var myId: String?
var allPhoneList: Dictionary<String, Any>?
var allFriendsInfo = [FriendInfo]()
var sentFriendRequest: Dictionary<String, Bool>?

class AuthService {
    
    private static let _instance = AuthService()
    static var instance: AuthService{
        return _instance
    }
    
    func firstLoadSet(){
        myId = FIRAuth.auth()?.currentUser?.uid
        DataService.instance.profileRef.observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if let userValue = snapshot.value as? Dictionary<String, Any> {
                myfirstName = userValue["firstName"] as? String
                mylastName = userValue["lastName"] as? String
                myphoneNumber = userValue["phoneNumber"] as? String
                myimageUrl = userValue["imageUrl"] as? String
                myusername = userValue["username"] as? String
            }
        })
        updateLocalFriendsList()
        
        DataService.instance.mainRef.child("PhoneNumber").observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if let value = snapshot.value as? Dictionary<String, Any> {
                allPhoneList = value
               
            }
           

        })
    }
    
    func updateLocalFriendsList(){
        DataService.instance.selfRef.child("friends").observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if let value = snapshot.value as? Dictionary<String, Any> {
                //friendsList = value
                for item in value{
                    let friendId = item.key
                    print(friendId)
                    DataService.instance.usersRef.child(friendId).child("profile").observeSingleEvent(of: .value, with: {(childSnapshot) -> Void in
                        if let childValue = childSnapshot.value as? Dictionary<String, Any> {
                            let firstName = childValue["firstName"] as? String
                            let lastName = childValue["lastName"] as? String
                            let fullName = firstName! + " " + lastName!
                            let phoneNumber = childValue["phoneNumber"] as? String
                            if let url = URL(string: childValue["imageUrl"] as! String) {
                                do {
                                    let data = try Data(contentsOf: url)
                                    let profileImage = UIImage(data: data)
                                    
                                    //No phone number in some previous test accounts 
                                    if let number = phoneNumber{
                                        let friend = FriendInfo(uid: friendId, fullName: fullName, firstName: firstName!, image: profileImage!, phoneNumber: number)
                                        allFriendsInfo.append(friend)
                                    } else{
                                        let friend = FriendInfo(uid: friendId, fullName: fullName, firstName: firstName!, image: profileImage!)
                                        allFriendsInfo.append(friend)
                                    }
                                    
                                }
                                catch{
                                    print(error.localizedDescription)
                                }
                            }
                        }
            })
                }
            }
        })
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String, username: String, phoneNumber: String, data: Data, onCompelte: Completion?){
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
                                    DataService.instance.saveUser(uid: user!.uid, username: username, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, data: data)
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
    
    
    func login(email: String, password: String, onCompelte: Completion?){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                self.handleFirebaseError(error: error!, onComplete: onCompelte)

            } else {
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
            case .errorCodeUserNotFound, .errorCodeWrongPassword:
                onComplete?("Invalid email address or password", nil)
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
