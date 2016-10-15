//
//  EditVC.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/15/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import CoreData

class EditVC: UIViewController {
    
    var itemToEdit : Item?

    
    @IBAction func save(_ sender: AnyObject) {
        createNewItem()
    }
    
    @IBAction func deleteItem(_ sender: AnyObject) {
        deleteItem()
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
            var myImage = UIImage(data: (itemToEdit?.image) as! Data)
            
           // myImage = Util.rotateImage(image: myImage!)
            editingImage.image =  myImage
            
        } else{
            var img = Util.rotateImage(image: _selectedImage)
            editingImage.image = img
        }
        
      
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction func sendToBtnPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "toUsersVC", sender: selectedImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UsersVC{
            if let image = sender as? UIImage{
                destination.image = image
            }
            
        }
    }
    
    func createNewItem(){
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Item", in: moc)
        
        let item = Item(entity: entityDescription!, insertInto: moc)
        
        
        //item.image = UIImagePNGRepresentation(editingImage.image!) as NSData?
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
        dismiss(animated: false, completion: nil)
    }
}


