//
//  AddVC.swift
//  SocialChat
//
//  Created by zheng chai on 30/09/2016.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit

class AddVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBAction func fromLib(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerController.allowsEditing = true
        
        self.present(pickerController, animated: true, completion: nil)
    }
    @IBAction func fromDevice(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        pickerController.allowsEditing = true
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var  image = UIImage()
        image = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //imageHolder.contentMode = .scaleAspectFit //3
        //imageHolder.image = image //4
        
        
        dismiss(animated:true, completion: nil)
        
        self.imageView.image = image
    }
    
    func dismissVC() {
        
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
