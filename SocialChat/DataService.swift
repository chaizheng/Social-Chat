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
    
    var mainStorageRef: FIRStorageReference{
        return FIRStorage.storage().reference(forURL: "gs://socialchat-b831e.appspot.com")
    }
    
    var imageStorageRef:FIRStorageReference{
        return mainStorageRef.child("images")
    }
    
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, Any> = ["firstName": "", "lastName": ""]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
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
    
}
