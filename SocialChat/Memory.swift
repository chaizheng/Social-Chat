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

class Memory: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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
        //cell.imageView?.image = UIImage(data: (item.image)! as Data)
        if let photo = item.image{
            cell.img?.image = UIImage(data: photo as Data)
    
        
        }
        return cell
    }

   

}
