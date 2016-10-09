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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        findContacts()

           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return marrContactsName.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactCell
        cell.nameLabel.text = marrContactsName[indexPath.row]
        
        cell.phoneLabel.text = marrContactsNumber[indexPath.row]
        return cell
        
        
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
        
        print(marrContactsName)
        print(marrContactsNumber)
        print(allPhoneList)
        
        
        return contacts
    }



}
