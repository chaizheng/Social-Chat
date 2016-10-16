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
import SDWebImage

class SendVC: JSQMessagesViewController{
    
    var messageRef: FIRDatabaseReference!
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
    
    
    
    private var _receiverId: String!
    private var _receiverName: String!
    private var imageUrl: String?

    var receiverId: String{
        get{
            return _receiverId
        }
        
        set{
            _receiverId = newValue
        }
    }
    
    var recieverName: String{
        get{
            return _receiverName
        }
        set{
            _receiverName = newValue
        }
    }
    
    
     //   var senderAvatar:JSQMessagesAvatarImage!
//    var usersAvatars:Dictionary<String, JSQMessagesAvatarImage>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        createOptionMenu()
        let currentUser = FIRAuth.auth()?.currentUser
        self.senderId = currentUser?.uid
        
        self.title = recieverName
        
        //set default value unless error
        self.senderDisplayName = ""
        observeUsers()
        setupBubbles()
        newobserveMessages()
    }
    
    // get DisplayName
    private func observeUsers(){
        DataService.instance.usersRef.child(self.senderId).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? Dictionary<String, Any>{
                let username = value["username"]
                let senderImageUrl = value["imageUrl"]
                self.imageUrl = senderImageUrl as? String
                self.senderDisplayName = username as? String
            } else{
                print("error displayname")
                self.senderDisplayName = "error"
            }}) { (error) in
                print(error.localizedDescription)
        }
        
    }
    
    // Avatar not used now
//    private func observeUsers(){
//        DataService.instance.usersRef.child(self.senderId).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
//            if let value = snapshot.value as? Dictionary<String, Any>{
//                let username = value["username"]
//                self.senderDisplayName = username as? String
//                do{
//                    let imageUrl = value["imageUrl"] as! String
//                    let url = URL(string: imageUrl)
//                    let data = try Data(contentsOf: url!)
//                    let picture = UIImage(data: data)
//                    self.senderAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: picture, diameter: 30)
//                    
//                } catch{
//                    print(error.localizedDescription)
//                }
//                
//            } else{
//                print("error displayname")
//                self.senderDisplayName = "error"
//            }}) { (error) in
//                print(error.localizedDescription)
//        }
//
//    }
    
    
    private func newobserveMessages(){
        
        let senderQuery = DataService.instance.usersRef.child(senderId).child("sentMessage").queryOrdered(byChild: "receiverId").queryEqual(toValue: self.receiverId)
        
        senderQuery.observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
            
            if let value = snapshot.value as? Dictionary<String, Any>{
                let contentType = value["contentType"] as! String
                let senderId = value["senderId"] as! String
                let senderName = value["senderName"] as! String
                if contentType == "TEXT" {
                    let text = value["content"] as! String
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                } else if contentType == "PHOTO" {
                    do{
                        let imageUrl = value["content"] as! String
                        let url = URL(string: imageUrl)
                        let data = try Data(contentsOf: url!)
                        let picture = UIImage(data: data)
                        let photo = JSQPhotoMediaItem(image: picture)
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                    } catch {
                        print(error.localizedDescription)
                    }
                } else if contentType == "VISIIMAGE"{
                    do{
                        let imageUrl = value["content"] as! String
                        let url = URL(string: imageUrl)
                        let data = try Data(contentsOf: url!)
                        var picture = UIImage(data: data)
                        picture = Util.rotateImage(image: picture!)
                        let photo = JSQPhotoMediaItem(image: picture)
                        photo?.accessibilityLabel  = "Tap me to watch it!"
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            self.finishReceivingMessage()
        }
        
        let receiverQuery = DataService.instance.usersRef.child(senderId).child("receivedMessage").queryOrdered(byChild: "senderId").queryEqual(toValue: self.receiverId)
        
        receiverQuery.observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
            
            if let value = snapshot.value as? Dictionary<String, Any>{
                let contentType = value["contentType"] as! String
                let senderId = value["senderId"] as! String
                let senderName = value["senderName"] as! String
                if contentType == "TEXT" {
                    let text = value["content"] as! String
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                } else if contentType == "PHOTO" {
                    do{
                        let imageUrl = value["content"] as! String
                        let url = URL(string: imageUrl)
                        let data = try Data(contentsOf: url!)
                        let picture = UIImage(data: data)
                        let photo = JSQPhotoMediaItem(image: picture)
                        photo?.appliesMediaViewMaskAsOutgoing = false
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                    } catch {
                        print(error.localizedDescription)
                    }
                } else if contentType == "VISIIMAGE"{
                    do{
                        let imageUrl = value["content"] as! String
                        let url = URL(string: imageUrl)
                        let data = try Data(contentsOf: url!)
                        var picture = UIImage(data: data)
                        picture = Util.rotateImage(image: picture!)
                        let photo = JSQPhotoMediaItem(image: picture)
                        photo?.accessibilityLabel  = "Tap me to watch it!"
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            self.finishReceivingMessage()
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
//        let message = messages[indexPath.row]
//        if message.senderId == senderId{
//            return senderAvatar
//        } else{
//            return nil
//        }
        return nil
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination =  segue.destination as? NormalImageVC{
            if let image = sender as? UIImage{
                destination.image = image
            }
        }
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.item]
        if message.isMediaMessage{
            if let mediaItem = message.media as? JSQPhotoMediaItem {
                performSegue(withIdentifier: "NormalImageVC", sender: mediaItem.image)
            }
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        DataService.instance.sendMessage(messageType: "TEXT", content: text, senderId: senderId, senderName: senderDisplayName, receiverId: self.receiverId, receiverName: self.recieverName, senderImageUrl: self.imageUrl!)

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
                DataService.instance.sendMessage(messageType: "PHOTO", content: imageUrl, senderId: self.senderId, senderName: self.senderDisplayName, receiverId: self.receiverId,receiverName: self.recieverName,senderImageUrl: self.imageUrl!)
                
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.finishSendingMessage()
            }
    }
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
    
}

extension SendVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sendMedia(picture: picture)
        }
        
        self.dismiss(animated: true, completion: nil)
        finishSendingMessage()
    }
}
