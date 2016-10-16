//
//  PictureViewController.swift
//  Photo Optimizer
//
//  Created by 黄 康平 on 10/8/16.
//  Copyright © 2016 黄 康平. All rights reserved.
//
//
//  ImageViewController.swift
//  Photo Optimizer
//
//  Created by 黄 康平 on 10/8/16.
//  Copyright © 2016 黄 康平. All rights reserved.
//


protocol PictureVCDelegate {
    func sendValue(visibleTime: String, image: UIImage)
}

import UIKit
import SpriteKit

class PictureViewController: UIViewController, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate:PictureVCDelegate?
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var newImage: UIImage?
    var emojiImage: UIImage?
    var emojiImageView: UIImageView?
    var location = CGPoint(x: 0, y: 0)
    var pickerData: [String] = [String]()
    
    var time = "5"
    var lastPoint = CGPoint.zero
    var drawColor = UIColor.black
    var red: CGFloat = 1.0
    var green: CGFloat = 1.0
    var blue: CGFloat = 1.0
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    var swiped = false
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]
    @IBOutlet weak var emojiCollection: UICollectionView!
    @IBOutlet weak var UserInput: UITextView!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawImageView: UIImageView!
    @IBOutlet weak var commitedImageView: UIImageView!
    @IBOutlet weak var Pencils: UIView!
    @IBOutlet weak var drawAction: UIButton!
    @IBOutlet weak var filterAction: UIButton!
    @IBOutlet weak var timePicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newImageView.image = newImage
        UserInput.delegate = self
        UserInput.isHidden = true
        emojiCollection.dataSource = self
        emojiCollection.delegate = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        emojiCollection.collectionViewLayout = layout
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(oneTapDetected))
        filterAction.addGestureRecognizer(oneTap)
        NotificationCenter.default.addObserver(self, selector: #selector(PictureViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PictureViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        UserInput.isUserInteractionEnabled = true
        pickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        
        // Do any additional setup after loading the view.
    }
    
    
    func oneTapDetected(sender: UITapGestureRecognizer) {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: newImage!)
        let filter = CIFilter(name: "CIPhotoEffectChrome" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        newImageView.image = UIImage(cgImage: filteredImageRef!)
        let twoTap = UITapGestureRecognizer(target: self, action: #selector(twoTapDetected))
        filterAction.addGestureRecognizer(twoTap)
    }
    
    func twoTapDetected(sender: UITapGestureRecognizer) {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: newImage!)
        let filter = CIFilter(name: "CIPhotoEffectTransfer" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        newImageView.image = UIImage(cgImage: filteredImageRef!)
        let threeTap = UITapGestureRecognizer(target: self, action: #selector(threeTapDetected))
        filterAction.addGestureRecognizer(threeTap)
    }
    
    func threeTapDetected(sender: UITapGestureRecognizer) {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: newImage!)
        let filter = CIFilter(name: "CIPhotoEffectInstant" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        newImageView.image = UIImage(cgImage: filteredImageRef!)
        let fourTap = UITapGestureRecognizer(target: self, action: #selector(fourTapDetected))
        filterAction.addGestureRecognizer(fourTap)
    }
    
    func fourTapDetected(sender: UITapGestureRecognizer) {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: newImage!)
        let filter = CIFilter(name: "CIPhotoEffectTonal" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        newImageView.image = UIImage(cgImage: filteredImageRef!)
        let fiveTap = UITapGestureRecognizer(target: self, action: #selector(fiveTapDetected))
        filterAction.addGestureRecognizer(fiveTap)
    }
    
    func fiveTapDetected(sender: UITapGestureRecognizer) {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: newImage!)
        let filter = CIFilter(name: "CIPhotoEffectProcess" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        newImageView.image = UIImage(cgImage: filteredImageRef!)
        let sixTap = UITapGestureRecognizer(target: self, action: #selector(sixTapDetected))
        filterAction.addGestureRecognizer(sixTap)
    }
    
    func sixTapDetected(sender: UITapGestureRecognizer) {
        newImageView.image = newImage
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(oneTapDetected))
        filterAction.addGestureRecognizer(oneTap)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        time = pickerData[row]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EmojiCell{
            
            cell.configureCell(id: indexPath.row+1)
            return cell
            
        } else{
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        //Original size of cell
        let width = (emojiCollection.bounds.width)/3
        let height = width
        return CGSize(width: width, height: height)
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        emojiImage = UIImage(named: "emoji\(indexPath.row+1).jpg")
        emojiImageView = UIImageView(image: emojiImage)
        emojiImageView?.frame = CGRect (x: self.view.frame.width/2, y: self.view.frame.height/2, width: 30, height: 30)
        self.view.addSubview(emojiImageView!)
        collectionView.isHidden = true
        emojiImageView?.isUserInteractionEnabled = true
        let myPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let myPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handleEmojiPinch))
        let myRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
        emojiImageView?.addGestureRecognizer(myPanGestureRecognizer)
        emojiImageView?.addGestureRecognizer(myPinchGestureRecognizer)
        myPinchGestureRecognizer.delegate = self
        emojiImageView?.addGestureRecognizer(myRotationGestureRecognizer)
        myRotationGestureRecognizer.delegate = self
        
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        if UserInput.text == "" {
            UserInput.isHidden = true
        }
        self.bottomConstraint.constant = newImageView.frame.size.height/2
        return true;
    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        // 5
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant = changeInHeight + 40
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.timePicker.isHidden = true
        self.view.endEditing(true)
        if UserInput.text == "" {
            UserInput.isHidden = true
        }
        self.bottomConstraint.constant = newImageView.frame.size.height/2
        swiped = false
        if let touch = touches.first as UITouch! {
            lastPoint = touch.location(in: self.view)            
            if red == 1 && green == 1 && blue == 1 {
                self.drawImageView.image = self.commitedImageView.image
                self.commitedImageView.image = nil
            }
        }
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        drawImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // 3
        context?.setLineCap(CGLineCap.round)
        
        if red == 1 && green == 1 && blue == 1 {
            context?.setLineWidth(10)
            context?.setBlendMode(CGBlendMode.clear)
        }
        else{            
            context?.setLineWidth(brushWidth)
            context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            context?.setBlendMode(CGBlendMode.normal)
        }
        
        // 4
        context?.strokePath()
        
        // 5
        drawImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        drawImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first as UITouch! {
            let currentPoint = touch.location(in: view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(commitedImageView.frame.size)
        commitedImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        drawImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        commitedImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        drawImageView.image = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func timeAction(_ sender: AnyObject) {
        timePicker.isHidden = false
    }
    
    @IBAction func pencilPressed(_ sender: AnyObject) {
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    
    
    @IBAction func TextInputAction(_ sender: UIButton) {
        UserInput.becomeFirstResponder()
        Pencils.isHidden = true
        UserInput.isHidden = false
        UserInput.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        red = 1.0
        green = 1.0
        blue = 1.0
    }
    
    @IBAction func drawAction(_ sender: UIButton) {
        Pencils.isHidden = false
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(nextTapDetected))
        drawAction.addGestureRecognizer(nextTap)
    }
    
    func nextTapDetected(sender: UITapGestureRecognizer) {
        Pencils.isHidden = true
        red = 1; green = 1; blue = 1
        let nextnextTap = UITapGestureRecognizer(target: self, action: #selector(nextnextTapDetected))
        drawAction.addGestureRecognizer(nextnextTap)
    }
    
    func nextnextTapDetected(sender: UITapGestureRecognizer) {
        Pencils.isHidden = false
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(nextTapDetected))
        drawAction.addGestureRecognizer(nextTap)
    }
    
    @IBAction func emojiAction(_ sender: UIButton) {
        Pencils.isHidden = true
        emojiCollection.isHidden = false
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
       
        mergeDrawnImages(forgroundImage: newImage!, backgroundImage: commitedImageView.image!)
        if emojiImageView != nil {
            mergeEmojiImages(forgroundImage: newImage!, backgroundImage: emojiImageView!)
        }
        let myString = UserInput.text!
        let NSUserInput = myString as NSString
        newImage = textToImage(drawText: NSUserInput, inImage: newImage!, atPoint: UserInput.center)
        
        let imageData = UIImageJPEGRepresentation(newImage!, 0.6)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        
//        let alert = UIAlertController(title: "Save Successfully", message: "Open your photo library to see it.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        
        delegate?.sendValue(visibleTime: time, image: newImage!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func mergeDrawnImages (forgroundImage : UIImage, backgroundImage : UIImage) {

        let bottomImage = forgroundImage
        let topImage = backgroundImage
        
        let size = backgroundImage.size
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage.draw(in: areaSize)
        
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
    }
    
    func mergeEmojiImages (forgroundImage : UIImage, backgroundImage : UIImageView) {
        
        let bottomImage = forgroundImage
        let topImage = backgroundImage.image
        
        let size = bottomImage.size
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: backgroundImage.frame.origin.x, y: backgroundImage.frame.origin.y, width: (backgroundImage.image?.size.width)!, height: (backgroundImage.image?.size.height)!)
        bottomImage.draw(in: CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height))
        
        topImage?.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
    
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage{
        
        // Setup the font specific variables
        
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: (UserInput.font?.pointSize)!)!
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x:0, y:0, width:inImage.size.width, height:inImage.size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x:atPoint.x, y:atPoint.y, width:inImage.size.width, height:inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        
        return newImage!
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(location, in: self.view)
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        
        UserInput.font = UserInput.font?.withSize(14*recognizer.scale)
    }
    
    func handleEmojiPinch(recognizer: UIPinchGestureRecognizer) {
        self.emojiImageView?.transform = CGAffineTransform(scaleX: recognizer.scale , y: recognizer.scale)
    }
    
    func handleRotation(recognizer : UIRotationGestureRecognizer) {
        recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
    }
    
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        delegate?.sendValue(visibleTime: time, image: newImage!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
        
        
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIS∫oryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    



}
