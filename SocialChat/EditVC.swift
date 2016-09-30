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

    
    @IBAction func save(_ sender: AnyObject) {
        createNewItem()
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
        editingImage.image = _selectedImage
      
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
        
        
        item.image = UIImagePNGRepresentation(editingImage.image!) as NSData?
        
        
        do{
            try moc.save()
        } catch {
            return
        }
        
        
        
    }
    
}
