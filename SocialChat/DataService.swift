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
            self.mainRef.child("Username").setValue(usernameDict)
            self.mainRef.child("PhoneNumber").setValue(phoneDict)
        }
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo:Dictionary<String, User>, mediaURL: URL, visibleTime: Int /*textSnippet: String? = nil*/) {
        
        var uids = [String]()
        for uid in sendingTo.keys{
            uids.append(uid)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd 'at' HH:mm"
        let sendTime = dateFormatter.string(from: Date())
        let pr: Dictionary<String, Any> = ["mediaURL":mediaURL.absoluteString,"senderID":senderUID,"receiversID": uids,"visibleTime": visibleTime,"sendTime": sendTime]
        
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
        
    }
    
    func sendFriendRequest(senderId: String, senderUsername: String, senderFullname: String, receiverId: String){
        
        let sendTime = Util.getCurrentTime()
        let senderSaveData:Dictionary<String, Any> = ["receiverId": receiverId, "sendTime": sendTime]
        let receiverSaveData:Dictionary<String, Any> = ["senderId": senderId, "senderUsername": senderUsername, "senderFullname": senderFullname, "sendTime": sendTime]
        
        let senderRef = usersRef.child(senderId).child("sentFriendRequest")
        let receiverRef = usersRef.child(receiverId).child("receivedFriendRequest")
        
        senderRef.setValue(senderSaveData)
        receiverRef.setValue(receiverSaveData)
    }
    
    
    // send message to sepecific receivers
    func sendMessage(messageType: String, content: String, senderId: String, senderName: String, receiverId: String, visibleTime: String? = nil){
        
        let sendTime = Util.getCurrentTime()
        let refName = "\(senderId)-\(receiverId)-\(sendTime)"
        let senderRef = usersRef.child(senderId).child("sentMessage").child(refName)
        let receiverRef = usersRef.child(receiverId).child("receivedMessage").child(refName)
        
        let sendMessageItem:Dictionary<String, Any> = ["content": content, "senderId": senderId,"senderName": senderName, "contentType": messageType, "sentTime": sendTime, "receiverId": receiverId]
        let receiveMessageItem:Dictionary<String, Any> = ["content": content,"senderId": senderId,"senderName": senderName, "contentType": messageType, "ReceivedTime": sendTime]
        
        senderRef.setValue(sendMessageItem)
        receiverRef.setValue(receiveMessageItem)
        
    }
    
}
