//
//  SendVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 29/09/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class SendVC: JSQMessagesViewController{
    
    var messageRef: FIRDatabaseReference!
    
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createOptionMenu()
        let currentUser = FIRAuth.auth()?.currentUser
        self.senderId = currentUser?.uid
        title = "ChatChat"
        
        DataService.instance.usersRef.child(senderId).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? Dictionary<String, Any>
            let username = value?["username"]
            self.senderDisplayName = username as! String!
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        self.senderDisplayName = "  "
        
        
        
        setupBubbles()
        messageRef = DataService.instance.mainRef.child("messages")
        observeMessages()
    }
    
    
    private func observeMessages() {
        let messagesQuery = messageRef.queryLimited(toLast: 25)
        messagesQuery.observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
            if let value = snapshot.value as? Dictionary<String, Any>{
                let mediaType = value["MediaType"] as! String
                let senderId = value["senderId"] as! String
                let senderName = value["senderName"] as! String
                if mediaType == "TEXT" {
                    let text = value["text"] as! String
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                } else if mediaType == "PHOTO" {
                    do{
                        let imageUrl = value["imageUrl"] as! String
                        let url = URL(string: imageUrl)
                        let data = try Data(contentsOf: url!)
                        let picture = UIImage(data: data)
                        let photo = JSQPhotoMediaItem(image: picture)
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                        
                        if self.senderId == senderId{
                            photo?.appliesMediaViewMaskAsOutgoing = true
                        } else{
                            photo?.appliesMediaViewMaskAsOutgoing = false
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                } else {
                    print("Unknown data type")
                }
                
                self.finishReceivingMessage()
            }
        }
    }

    
    private func createOptionMenu() {
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (alert: UIAlertAction) -> Void in
            self.photoLibrary()
        })
        let memoryAction = UIAlertAction(title: "Memories", style: .default, handler: { (alert: UIAlertAction) -> Void in
            self.memory()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(memoryAction)
        optionMenu.addAction(cancelAction)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupBubbles(){
        let factory = JSQMessagesBubbleImageFactory()!
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImageView = factory.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId{
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    // profile image add later!!!!!!!!!!
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
  
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
//        let message = messages[indexPath.item]
//        if message.isMediaMessage{
//            if let mediaItem = message.media as? JSQPhotoMediaItem {
//                
//                
//            }
//        }
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
//        cell.textView.font = UIFont(name: "Avenir Next Medium", size: 17)
//        return cell
//    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let itemRef = messageRef.childByAutoId()
        let messageItem:Dictionary<String, Any> = ["text": text,"senderId": senderId,"senderName": senderDisplayName, "MediaType": "TEXT"]
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        present(optionMenu, animated: true, completion: nil)
    }
    
    func memory(){
        
    }
    
    func photoLibrary(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func sendMedia(picture: UIImage) {
       
            let filePath = "\(senderId!)/\(Date.timeIntervalSinceReferenceDate)"
            let ref = DataService.instance.imageStorageRef.child(filePath)
            let data = UIImageJPEGRepresentation(picture, 0.5)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            ref.put(data!, metadata: metadata) { (metadata, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
                let imageUrl = metadata!.downloadURLs![0].absoluteString
                let itemRef = self.messageRef.childByAutoId()
                let messageItem:Dictionary<String, Any> = ["imageUrl": imageUrl,"senderId": self.senderId,"senderName": self.senderDisplayName, "MediaType": "PHOTO"]
                itemRef.setValue(messageItem)
                }
        }
    
    
    
    
}
extension SendVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            let photo = JSQPhotoMediaItem(image: picture)
//            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
            sendMedia(picture: picture)
        }
        
        self.dismiss(animated: true, completion: nil)
        finishSendingMessage()
    }
}
