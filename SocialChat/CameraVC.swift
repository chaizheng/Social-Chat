//
//  ViewController.swift
//  SocialChat
//
//  Created by ZhangJeff on 9/10/16.
//  Copyright © 2016 Social Media Coders. All rights reserved.
//

import UIKit
import FirebaseAuth
import AVFoundation
import ImageIO

// global variables
var firstLoad: Bool = true
var isBackCamera : Bool = true
var isFlash : Bool = false
var captureSession : AVCaptureSession?
var stillImageOutput : AVCaptureStillImageOutput?
var previewLayer : AVCaptureVideoPreviewLayer?

class CameraVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var cameraView: UIView!

    @IBOutlet weak var goMemBtn: UIButton!
    @IBOutlet weak var logoBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var changeCamBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        performSegue(withIdentifier: "LoginVC", sender: nil)
        guard FIRAuth.auth()?.currentUser != nil else {
            performSegue(withIdentifier: "LoginVC", sender: nil)
            return
        }
      

        }
    
    // Create camera view
    func reloadCamera(){
        
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = AVCaptureSessionPresetHigh
        
      
        var captureDevice:AVCaptureDevice! = nil
        
        if isBackCamera == false {
            
            let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for device in videoDevices!{
                let device = device as! AVCaptureDevice
                if device.position == AVCaptureDevicePosition.front {
                    captureDevice = device
            }
            }
        } else{
            captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        }
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            if (captureSession?.canAddInput(input))!{
                captureSession?.addInput(input)
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                
                if (captureSession?.canAddOutput(stillImageOutput))!{
                    captureSession?.addOutput(stillImageOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    cameraView.layer.addSublayer(previewLayer!)
                    previewLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

                    captureSession?.startRunning()
                    firstLoad = false
                }
            }
        }
        catch let err as NSError{
            print(err.debugDescription)
        }

    }
    // turn on flashlight for backcamera
    func toggleFlash(){
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasFlash)!{
            if isFlash {
                do {
                    try device?.lockForConfiguration()
                    device?.flashMode = AVCaptureFlashMode.on
                    device?.unlockForConfiguration()
                    
                } catch let err as NSError{
                    print(err.debugDescription)
                }
            } else {
                do {
                    try device?.lockForConfiguration()
                    device?.flashMode = AVCaptureFlashMode.off
                    device?.unlockForConfiguration()
                    
                } catch let err as NSError{
                    print(err.debugDescription)
                }
            }
        }
    }
    
    func didPressTakePhoto(){
        toggleFlash()
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    
                    let tookPhoto = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.performSegue(withIdentifier: "editImage", sender: tookPhoto)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditVC{
            if let photo = sender as? UIImage {
                destination.selectedImage = photo             }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if firstLoad{
            reloadCamera()
        } else {
            //keep camera seesion running otherwise lag
            isFlash ? flashBtn.setImage(#imageLiteral(resourceName: "flash_Btn"), for: UIControlState.normal) : flashBtn.setImage(#imageLiteral(resourceName: "flashoff_Btn"), for: UIControlState.normal)
            cameraView.layer.addSublayer(previewLayer!)
            previewLayer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    @IBAction func flashBtnPressed(_ sender: AnyObject) {
        
        if isFlash{
            flashBtn.setImage(#imageLiteral(resourceName: "flashoff_Btn"), for: UIControlState.normal)
            isFlash = false
        } else{
            flashBtn.setImage(#imageLiteral(resourceName: "flash_Btn"), for: UIControlState.normal)
            isFlash = true
        }
    }
    
    @IBAction func recordBtnPressed(_ sender: AnyObject) {
        didPressTakePhoto()
    }
    
    @IBAction func changeCamBtnPressed(_ sender: AnyObject) {
        isBackCamera = !isBackCamera
        captureSession?.stopRunning()
        reloadCamera()
        
    }
    
    @IBAction func logoBtnPressed(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logoBtnPressed"), object: nil)

    }
    
    @IBAction func goMemBtnPressed(_ sender: AnyObject) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goMemBtnPressed"), object: nil)
    }

}

