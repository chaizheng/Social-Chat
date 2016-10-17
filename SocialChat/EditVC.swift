//
//  EditVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/15/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Social

class EditVC: UIViewController,PictureVCDelegate {
    
    var itemToEdit : Item?
    var lockIsOn = false
    var visibleTime: String = "5"


    @IBAction func socialShare(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "share", message: "please share your photo", preferredStyle: .actionSheet)
        let error = UIAlertController(title: "", message: "you do not login", preferredStyle: .alert)
        
        let sinaAction = UIAlertAction(title: "share on SinaWeibo", style: UIAlertActionStyle.default){(action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeSinaWeibo){
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeSinaWeibo){
                    let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
                    facebookComposeVC?.add(self.editingImage.image)
                    //facebookComposeVC?.setInitialText("nmb")
                    self.present(facebookComposeVC!, animated: false, completion: nil)
                }
                
            }
            else{
                
                self.present(error, animated: false, completion: nil)
            }
        }
        let fbAction = UIAlertAction(title: "share on facebook", style: .default){(action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposeVC?.setInitialText("nmb")
                self.present(facebookComposeVC!, animated: false, completion: nil)
            }
        }
       
        let dismissAction = UIAlertAction(title: "close", style: .cancel) {(action) -> Void in    }
        
        actionSheet.addAction(sinaAction)
        actionSheet.addAction(fbAction)
        
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)

    }
    
    @IBOutlet var lockButton: UIButton!
    
    @IBAction func tapLock(_ sender: AnyObject) {
    
        lockIsOn = !lockIsOn
        lockState()
    }
    
    func lockState(){
        if lockIsOn{
            lockButton.setImage(#imageLiteral(resourceName: "Lock Filled-52"), for: UIControlState(rawValue: UInt(0)))
        } else{
            lockButton.setImage(#imageLiteral(resourceName: "Unlock Filled-52"), for: UIControlState(rawValue: UInt(0)))
        }
    }
    
    func saveToMemory(){
        createNewItem()
        let alert = UIAlertController(title: "Save Successfully", message: "You can check it in Memory view now", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    

    @IBAction func save(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Save Image", message: "Save your image in your memory or camera roll", preferredStyle: .actionSheet)
        let memoryAction = UIAlertAction(title: "Memory", style: .default){
            (action) -> Void in
            self.saveToMemory()
        }
        
        let cameraRollAction = UIAlertAction(title: "Camera roll", style: .default){
            (action) -> Void in
         
            let imageData = UIImageJPEGRepresentation(self.editingImage.image!, 0.6)
            let compressedJPEGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil);
        }
        let dismissAction = UIAlertAction(title: "dismiss", style: .cancel, handler: nil)
        actionSheet.addAction(memoryAction)
        actionSheet.addAction(dismissAction)
        actionSheet.addAction(cameraRollAction)
        present(actionSheet, animated: false, completion: nil)
    }
    
    @IBAction func deleteItem(_ sender: AnyObject) {
        if lockIsOn == false{
            deleteItem()
            dismiss(animated: true, completion: nil)

        } else{
            let alert = UIAlertController(title: "warning", message: "sorry, the photo is locked, you can't delete or edit it", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "dismiss", style: .cancel) {(action) -> Void in    }
            alert.addAction(dismissAction)
            present(alert, animated: false, completion: nil)
        }
            }
    @IBOutlet weak var editingImage: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendToBtn: UIButton!
    
    private var _selectedImage: UIImage!
    
    var selectedImage: UIImage {
        get {
            return _selectedImage
        } set {
            _selectedImage = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if itemToEdit != nil{
            let myImage = UIImage(data: (itemToEdit?.image) as! Data)
            editingImage.image =  myImage
            
        } else{
            let img = Util.rotateImage(image: _selectedImage)
            editingImage.image = img
        }
        lockState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction func sendToBtnPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "toUsersVC", sender: (selectedImage,visibleTime))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UsersVC{
            if let imageTime = sender as? (UIImage,Int){
                destination.image = imageTime.0
                destination.visibleTime = imageTime.1
                
            }
        }
        
        if let destination = segue.destination as? PictureViewController{
            if let image = sender as? UIImage{
                destination.delegate = self
                destination.newImage = image
            }
        }
        
        if let destination = segue.destination as? FaceDetect{
            if let image = sender as? UIImage{
               print(image)
                destination.newImage = image
            }
        }
       

    }
    
    func createNewItem(){
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Item", in: moc)
        
        let item = Item(entity: entityDescription!, insertInto: moc)
        
        item.image = UIImageJPEGRepresentation(Util.rotateImage(image: editingImage.image!), 1.0) as NSData?
        
        do{
            try moc.save()
        } catch {
            return
        }
        
    }
    
    func deleteItem(){
        if itemToEdit != nil{
            moc.delete(itemToEdit!)
            
        }
        do {
            try moc.save()
        } catch {
            print("Failed to save")
            return
        }
      //  dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func shareToStoryBtnPressed(_ sender: AnyObject) {
        
        let filePath = "\(myId!)/\(Date.timeIntervalSinceReferenceDate)"
        let ref = DataService.instance.imageStorageRef.child(filePath)
        
        let data = UIImageJPEGRepresentation(selectedImage, 0.5)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        
        _ = ref.put(data!, metadata: metadata) { (metadata, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            let storyUrl = metadata!.downloadURLs![0].absoluteString
            DataService.instance.shareStories(storyUrl: storyUrl, senderId: myId!, senderName: myfirstName!, senderImageUrl: myimageUrl!, visibleTime: self.visibleTime)
        }
        
        let alert = UIAlertController(title: "Share Successfully", message: "Now your friends can watch it!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func EditBtnPressed(_ sender: AnyObject) {
        if self.lockIsOn == true{
            let alert = UIAlertController(title: "Locked Image", message: "You can't edit locked image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let sendImage = Util.rotateImage(image: selectedImage)
            performSegue(withIdentifier: "PictureViewController", sender: sendImage)
        }
    }
    
    func sendValue(visibleTime: String, image: UIImage) {
        self.visibleTime = visibleTime
        self.selectedImage = image
        self.editingImage.image = image
    }
    
    @IBAction func faceDetect(_ sender: AnyObject) {
        performSegue(withIdentifier: "faceDetect", sender: editingImage.image)
        
    }
    
}


