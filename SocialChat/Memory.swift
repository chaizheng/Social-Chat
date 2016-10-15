//
//  Memory.swift
//  SocialChat
//
//  Created by zheng chai on 30/09/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class Memory: UICollectionViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var  image = UIImage()
    
     var frc : NSFetchedResultsController<Item> = NSFetchedResultsController()
    
    func fetchRequest() -> NSFetchRequest<Item>{
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func getFRC() -> NSFetchedResultsController<Item> {
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        frc = getFRC()
        frc.delegate = self
        
        do{
            try frc.performFetch()
        } catch {
            print("Failed to perform initial fetch")
            return
        }
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

         self.collectionView!.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        frc = getFRC()
        frc.delegate = self
        
        do{
            try frc.performFetch()
        } catch {
            print("Failed to perform initial fetch")
            return
        }
        
        self.collectionView?.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let sections = frc.sections{
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let item = frc.object(at: indexPath)
        if let photo = item.image{
            var myImage = UIImage(data: photo as Data)
           
            myImage = Util.rotateImage(image: myImage!)
            cell.img?.image =  myImage
            
        
        }
        return cell
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "Edit"{
            let cell = sender as! CollectionViewCell
            let indexPath = collectionView?.indexPath(for: cell)
            let itemController : EditVC = segue.destination as! EditVC
            let item : Item = frc.object(at: indexPath!)
            itemController.itemToEdit = item
        }
    }

    @IBAction func addFromDevice(_ sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerController.allowsEditing = true
        
        self.present(pickerController, animated: true, completion: nil)
        createNewItem()

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let myImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//         image = UIImage(cgImage: myImage, scale: 1.0, orientation: UIImageOrientation.right)
        
        
        dismiss(animated:true, completion: nil)
        
      
    }

    
    func createNewItem(){
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Item", in: moc)
        
        let item = Item(entity: entityDescription!, insertInto: moc)
        
        
        item.image = UIImagePNGRepresentation(image) as NSData?
        
        
        do{
            try moc.save()
        } catch {
            return
        }
        
        
        
    }
   

}
