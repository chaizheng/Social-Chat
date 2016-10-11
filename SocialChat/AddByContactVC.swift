//
//  AddByContactVC.swift
//  SocialChat
//
//  Created by zheng chai on 9/10/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import Contacts

class AddByContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

 
   
    @IBOutlet var tableView: UITableView!
    
    var marrContactsNumber = [String]()
    var marrContactsName = [String]()
    //compare the of element in addressbook similar to database
    var num = [Bool]()
    //compare whether the user have already in the database
    var added = [Bool]()
    
    var friendId: String?
    var selectIndex :Int?
    
    
    func getfriendId() -> String{
        return friendId!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        findContacts()
        phoneUser()
        
        tableView.reloadData()
        print(allFriendsInfo)

           }
    
    
    
    func findKeyforValue(phoneNum: String, dic: Dictionary<String, Any> ) -> String{
        for (key, value) in dic{
            if value as! String == phoneNum{
                return key
            }
        }
        return "no key matched"
    }

    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return marrContactsName.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactCell
        cell.nameLabel.text = marrContactsName[indexPath.row]
        
        cell.phoneLabel.text = marrContactsNumber[indexPath.row]
        
        if num[indexPath.row] == true {
            cell.addFriend.isHidden = false
            
        } else{
            cell.addFriend.isHidden = true
        }
        
        cell.friendId = findKeyforValue(phoneNum: marrContactsNumber[indexPath.row], dic: allPhoneList!)
        
              return cell
        
        
    }
    
    func phoneUser() -> [Bool] {
    
        
        for v in (allPhoneList?.values)!{
            
            while num.count < marrContactsNumber.count {
                num.append(false)
            }
            

            
            if marrContactsNumber.contains(v as! String){
                let index = marrContactsNumber.index(of: v as! String)
               
                num[index!] = true
                
                
            }
           
        
               }
        
        return num
    }
    
    func findContacts() -> [CNContact] {
        marrContactsNumber.removeAll()
        marrContactsName.removeAll()
        
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        var contacts = [CNContact]()
        
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: {( contact, stop) -> Void in contacts.append(contact)
                //self.marrContactsNumber.append(contact.phoneNumbers)
                var phonenum = (contact.phoneNumbers[0].value as CNPhoneNumber).value(forKey: "digits") as! String
                self.marrContactsNumber.append(phonenum)
                self.marrContactsName.append(contact.givenName + "" + contact.familyName)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
      
        
       
        return contacts
    }



}
