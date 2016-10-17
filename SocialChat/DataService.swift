//
//  DataService.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/12/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

let FIR_CHILD_USERS = "users"

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class DataService {
    private static let _instance = DataService()
    static var instance: DataService{
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference{
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    var selfRef: FIRDatabaseReference{
        return usersRef.child((FIRAuth.auth()?.currentUser?.uid)!)
    }
    
    var profileRef: FIRDatabaseReference{
        return selfRef.child("profile")
    }
    
    var mainStorageRef: FIRStorageReference{
        return FIRStorage.storage().reference(forURL: "gs://socialchat-b831e.appspot.com")
    }
    
    var imageStorageRef:FIRStorageReference{
        return mainStorageRef.child("images")
    }
    
    func saveUser(uid: String, username: String, firstName: String, lastName: String, phoneNumber: String, data: Data) {
        
        let filePath = "profileImage/\(uid)"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = mainStorageRef.child(filePath).put(data, metadata: metadata) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let imageUrl = metadata?.downloadURLs![0].absoluteString
            let profile: Dictionary<String, Any> = ["username": username, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "imageUrl": imageUrl!]
            let usernameDict: Dictionary<String, Any> = [uid:username]
            let phoneDict: Dictionary<String, Any> = [uid:phoneNumber]
            self.mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
            self.mainRef.child("Username").updateChildValues(usernameDict)
            self.mainRef.child("PhoneNumber").updateChildValues(phoneDict)
        }
    }
    
    
    func sendFriendRequest(senderId: String, senderUsername: String, senderFullname: String, receiverId: String, senderImageUrl: String){
        
        let sendTime = Util.getCurrentTime()
        let senderSaveData:Dictionary<String, Any> = ["receiverId": receiverId, "sendTime": sendTime]
        let receiverSaveData:Dictionary<String, Any> = ["senderId": senderId, "senderUsername": senderUsername, "senderFullname": senderFullname, "sendTime": sendTime, "senderImageUrl": senderImageUrl]
        
        let refName = "\(senderId)-\(receiverId)"
        let senderRef = usersRef.child(senderId).child("sentFriendRequest").child(refName)
        let receiverRef = usersRef.child(receiverId).child("receivedFriendRequest").child(refName)
        
        senderRef.setValue(senderSaveData)
        receiverRef.setValue(receiverSaveData)
    }

    
    // send message to sepecific receivers
    func sendMessage(messageType: String, content: String, senderId: String, senderName: String, receiverId: String, receiverName: String, senderImageUrl: String, visibleTime: Int? = nil){
        
        let sendTime = Util.getCurrentTime()
        let refName = "\(senderId)-\(receiverId)-\(sendTime)"
        let senderRef = usersRef.child(senderId).child("sentMessage").child(refName)
        let receiverRef = usersRef.child(receiverId).child("receivedMessage").child(refName)
        let sendMessageItem:Dictionary<String, Any>!
        let receiveMessageItem:Dictionary<String, Any>!
        
        if visibleTime == nil{
            sendMessageItem = ["content": content, "senderId": senderId,"senderName": senderName, "contentType": messageType, "sentTime": sendTime, "receiverId": receiverId, "receiverName": receiverName]
        } else{
            sendMessageItem = ["content": content, "senderId": senderId,"senderName": senderName, "contentType": messageType, "sentTime": sendTime, "receiverId": receiverId, "receiverName": receiverName, "visibleTime": visibleTime!]
        }
        
        //Normal image or text
        if visibleTime == nil{
            receiveMessageItem = ["content": content,"senderId": senderId,"senderName": senderName, "contentType": messageType, "ReceivedTime": sendTime, "senderImageUrl": senderImageUrl]
        }
        //Image set visible time
        else{
            receiveMessageItem = ["content": content,"senderId": senderId,"senderName": senderName, "contentType": messageType, "ReceivedTime": sendTime, "senderImageUrl": senderImageUrl, "visibleTime": visibleTime!]
        }
        
        senderRef.setValue(sendMessageItem)
        receiverRef.setValue(receiveMessageItem)
        
    }
    
    
    
    // share story to all friends
    func shareStories(storyUrl: String, senderId: String, senderName: String, senderImageUrl: String, visibleTime: String){
        
        let sendTime = Util.getCurrentTime()
        let refName = "\(senderId)-\(sendTime)"
        var receiverIds = [String]()
        
        // no friends then do nothing
        if allFriendsInfo.count == 0{
            return
        }
        
        for friend in allFriendsInfo{
            receiverIds.append(friend.uid)
        }
        
        // only save data in receivers' database
        let receiverItem:Dictionary<String, Any> = ["storyUrl": storyUrl,"senderId": senderId,"senderName": senderName,  "sendTime": sendTime, "senderImageUrl": senderImageUrl, "visibleTime": visibleTime]
        
        for receiverId in receiverIds{
            let receiverRef = usersRef.child(receiverId).child("receivedStories").child(refName)
            receiverRef.setValue(receiverItem)
        }
    }
    
    

}
